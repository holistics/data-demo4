# Construct catalog

Every SQL construct you can recognise, and where it lands. Read before classifying.

**This catalog is seeded, not exhaustive.** It was built from real customer queries and grows from
real customer queries. Anything you cannot match here goes to the **unrecognised constructs**
section of the conversion record *and* gets appended to `patterns-inbox.md`.

**Recognise the family, not the syntax.** `row_number() OVER (…) = 1` and
`FIRST_VALUE(…) OVER (…)` with `SELECT DISTINCT` are the same intent written two ways. Match on what
the construct is doing, not on the function name.

AML examples follow demo4's existing style (`definition: @aql …;;`, pipe syntax
`model | agg(…) | where(…)`). **Verify syntax with `search-docs` / `develop-amql` before writing** —
these show shape and placement, not guaranteed-current grammar.

---

## 1. Structurally dangerous

Patterns where the naive conversion produces plausible numbers that are wrong.

### 1.1 Composite join key

**Signature:** every `JOIN … ON` carries a second predicate on the same discriminator column
(`AND a.tenant_id = b.tenant_id`, `AND a.region = b.region`).

```sql
INNER JOIN etl.LoanAdjudication adj
    ON adj.Id = la.LoanAdjudication_Id
   AND adj.TenantIdentifier = la.TenantIdentifier
```

**Placement:** relationships are **equi-join only and cannot be composite**. Build a compound-key
dimension on both sides and relate those.

```aml
dimension adjudication_key {
  label: 'Adjudication Key'
  type: 'text'
  hidden: true
  definition: @sql concat({{ #SOURCE.LoanAdjudication_Id }}, '|', {{ #SOURCE.TenantIdentifier }});;
}
```

```aml
relationship(loan_applications.adjudication_key > loan_adjudications.adjudication_key, true)
```

Use an explicit separator. `concat(id, tenant)` collides when `id='1', tenant='23'` meets
`id='12', tenant='3'`.

**Before you build these, ask the tenancy question.** A discriminator on *every* join in a
multi-tenant platform is usually a **security boundary**, and in Holistics that is a row-level
permission, not a join key. Eleven compound keys where one permission rule belonged is the
over-build; dropping the predicate without the permission is a cross-tenant leak. Flag it, keep
converting what was asked for.

**Silent failure if ignored:** cross-tenant fan-out. Totals inflate, every row still looks valid.

### 1.2 Same table joined N times with different filters

**Signature:** several derived tables or CTEs over one source table, each with a different `WHERE`,
each joined back to the same parent.

```sql
LEFT JOIN (SELECT loanApplication_ID, MIN(UpdateDateTime) AS StatusChangeDateTime
           FROM etl.LoanApplicationHistory WHERE ApplicationStatus = 5
           GROUP BY loanApplication_ID) AcceptedByBorrower ON …
LEFT JOIN (SELECT loanApplication_ID, MIN(UpdateDateTime) AS StatusChangeDateTime
           FROM etl.LoanApplicationHistory WHERE ApplicationStatus = 7
           GROUP BY loanApplication_ID) ApprovedByReviewer ON …
```

**Placement:** **one relationship plus filtered measures.** Not N relationships.

```aml
measure accepted_by_borrower_at {
  label: 'Accepted By Borrower At'
  type: 'datetime'
  definition: @aql loan_application_history
    | min(loan_application_history.update_datetime)
    | where(loan_application_history.application_status == 5);;
}
```

Then the coalescing metric in the dataset:

```aml
metric response_date {
  label: 'Response Date'
  type: 'datetime'
  definition: @aql coalesce(approved_by_reviewer_at, accepted_by_borrower_at);;
}
```

Two measures feeding one metric is the rule-5 carve-out in the SKILL — this is what it is for.

**Why not N relationships:** Holistics *does* rank ambiguous paths, and
`relationship(…, false)` plus `with_relationships()` would work. Reserve that for genuinely
different **roles** of one dimension (`user_city` vs `merchant_city`). For "same table, different
filter" it bloats the dataset surface and pushes join mechanics back into the report layer, which is
exactly what the semantic layer should absorb.

### 1.3 EAV / attribute pivot

**Signature:** one key-value table filtered several ways by an attribute-name column, each result
deduped and joined back as a column.

```sql
POD_CTE AS (SELECT LoanAdjudication_Id, Value, ROW_NUMBER() OVER (…) AS VR
            FROM etl.Metric WHERE MetricDefinition_Identifier = 'ProbabilityOfDefault')
```

**Placement:** two viable shapes, pick by how many attributes there are and whether the list is
stable.

- **Few, stable attributes** → pivot once in a query model (the dedup has to be there anyway, 4.1),
  producing one wide model with a typed column per attribute. Downstream stays clean AML.
- **Many or growing attributes** → keep the tall model, expose the attribute name as a dimension,
  and define one filtered metric per attribute the report needs.

Values in an EAV table are almost always stored as text. Cast explicitly and handle the empty
string, which is not null:

```sql
IIF(pod.Value IS NULL OR pod.Value = '', NULL, CAST(pod.Value AS DECIMAL(5,4)))
```

**Gotcha:** the tall shape hits 1.2 as well — three attributes means three joins to one table.

### 1.4 Many-to-many bridge collapsed to a string

**Signature:** `STRING_AGG` / `GROUP_CONCAT` / `LISTAGG` over a bridge table, joined back as one
comma-separated column.

```sql
LEFT JOIN (SELECT lap.LoanApplication_Id,
                  STRING_AGG(p.Name, ', ') WITHIN GROUP (ORDER BY lap.Id) AS LoanType
           FROM etl.LoanApplicationProduct lap
           INNER JOIN etl.Product p ON p.Id = lap.ProductId
           WHERE lap.LoanAmount > 0
           GROUP BY lap.LoanApplication_Id) loanType ON …
```

**Placement:** **dataset metric with SQL passthrough.** Do not demote to a query model — passthrough
exists precisely for this.

```aml
metric loan_types {
  label: 'Loan Types'
  type: 'text'
  definition: @aql loan_application_products
    | agg_text('STRING_AGG', products.name, ', ')
    | where(loan_application_products.loan_amount > 0);;
}
```

`agg_text` is database-specific — `STRING_AGG` on Postgres/MSSQL, `GROUP_CONCAT` on MySQL,
`LISTAGG` on Snowflake/Oracle. Match it to the **target** warehouse, not the source dialect.

Also model the bridge properly. The string is the old tool's workaround; once the bridge is a real
model the customer gets counts and breakdowns by product that the string cannot give.

### 1.5 `COUNT(DISTINCT …)` across a fan-out join

**Signature:** `count(distinct x)` where `x` comes from the one-side of a one-to-many join.

Usually a workaround for fan-out the author already knew about. Do **not** copy it verbatim — it
hides whether the intended grain was the parent or the child. Escalate: state both readings and the
number each produces, and let a human choose.

### 1.6 Header-level aggregate across a line-level join

**Signature:** `SUM(orders.total)` where `orders` is joined to `order_items`.

The original query is already double-counting, unless something upstream deduped. Say so.
Reproducing it ships a known bug; silently fixing it makes your numbers differ from the report the
customer trusts. Both are worse than naming it.

---

## 2. Relocate or drop

Presentation logic. It moves; it does not vanish. Deleting a `FORMAT()` call without setting the
viz field format ships a report the customer immediately notices is uglier.

| Pattern | Example | Destination |
| --- | --- | --- |
| Date formatting | `FORMAT(la.CreatedDateTime, 'yyyy-MM-dd')` | **Viz field formatting** |
| Time-of-day extraction | `FORMAT(la.CreatedDateTime, 'HH:mm:ss')` | **Viz field formatting** on the datetime dimension |
| Number-to-text cast | `CONVERT(VARCHAR, CAST(la.BNIScore AS INT))` | **Drop the cast**, keep a `number` dimension, set the format |
| Null-to-blank | `ISNULL(la.AccountManager, '')` | **Drop.** Destroys the null semantics filters and `is null` rely on |
| Run timestamp column | `FORMAT(DATEADD(HOUR,-7,GETDATE()),'yyyy-MM-dd HH:mm') AS RunDate` | **Drop.** A report artifact with no business meaning |
| Sentinel date | `WHEN … = '1900-01-01' THEN NULL` | **Drop the guard**, fix the value in the model or open a DQ note |
| Bracketed identifiers | `AS [FICO Range]` | Model dimension `fico_range` with `label: 'FICO Range'` |

**Never leave a numeric cast to text.** `CONVERT(VARCHAR, CAST(score AS INT))` makes the column
unsummable, unsortable, and unfilterable by range. It is the single most damaging presentation
habit in BI SQL.

### 2.1 Derived date-part explosion

**Signature:** several output columns all computed from one timestamp.

```sql
, CONVERT(DATE, la.CreatedDateTime)                                    AS ApplicationDate
, FORMAT(la.CreatedDateTime, 'HH:mm:ss')                               AS ApplicationTime
, YEAR(la.CreatedDateTime)                                             AS ApplicationYear
, DATEADD(DAY, 1, EOMONTH(la.CreatedDateTime, -1))                     AS ApplicationMonthDate
, DATENAME(MONTH, la.CreatedDateTime)                                  AS ApplicationMonthName
, 'Week ' + RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(WEEK, …)), 2)    AS ApplicationYearWeekNo
, DATEADD(DAY, 2 - DATEPART(WEEKDAY, …), CAST(… AS DATE))              AS ApplicationYearWeekDate
```

**Placement:** **one `datetime` dimension.** Granularity is chosen in the report; drills come free.

Six columns to one is usually the most visible win in the whole conversion. Call it out explicitly
in the record — it is the concrete answer to "why bother modelling this".

**Gotcha:** T-SQL `DATEPART(WEEKDAY, …)` depends on `SET DATEFIRST`, so the week boundary is
session- and locale-dependent. Confirm the intended week start rather than porting the arithmetic.

---

## 3. AQL does it better

The SQL does these the hard way because its tool had no semantic layer.

### 3.1 Code-to-label decode

**Signature:** a long `CASE` mapping integer codes to display strings.

```sql
CASE WHEN la.ApplicationStatus = -1 THEN 'None'
     WHEN la.ApplicationStatus = 0 THEN 'Created'
     … 18 branches …
     ELSE 'ERROR' END AS ApplicationStatus
```

**Placement:** a **lookup model** (seed/CSV or a real reference table) related to the fact, so the
mapping lives in one place. A `case()` dimension is acceptable for a short, stable list, but past
roughly six branches, or where the same codes appear on more than one model, copy-paste drift is
guaranteed.

Keep the raw code as a hidden dimension. Someone will need it.

Preserve the `ELSE 'ERROR'` intent — an unmapped code is a data-quality signal, not a display
problem. Open a DQ note rather than silently returning null.

### 3.2 Bucketing `CASE`

```sql
CASE WHEN la.FICOScore < 580 THEN 'Poor (<580)'
     WHEN la.FICOScore BETWEEN 580 AND 669 THEN 'Fair (580-669)'
     … END AS [FICO Range]
```

**Placement:** **model dimension**, row-level and reusable.

```aml
dimension fico_range {
  label: 'FICO Range'
  type: 'text'
  definition: @aql case(
    when: loan_applications.fico_score < 580,   then: 'Poor (<580)',
    when: loan_applications.fico_score <= 669,  then: 'Fair (580-669)',
    when: loan_applications.fico_score <= 739,  then: 'Good (670-739)',
    when: loan_applications.fico_score <= 799,  then: 'Very Good (740-799)',
    else: 'Exceptional (800+)'
  );;
}
```

**Exception:** if the bucketing is this chart's slicing rather than a company-wide convention, it
belongs in the report layer as an advanced condition.

**Signal:** the same boundaries applied to two different columns (`RequestedLoanAmount` and
`LoanAmount` both bucketed `<25k / 25k-49,999 / …`) means a shared convention. Define it once and
note that both fields use it.

### 3.3 Filtered aggregate

`SUM(CASE WHEN x THEN y END)` → a filtered metric.

```aml
metric completed_revenue {
  label: 'Completed Revenue'
  type: 'number'
  definition: @aql (order_items | sum(order_items.amount))
    | where(orders.status == 'completed');;
}
```

Where the condition is complex enough that a `where` clause obscures it, keep the `case()` inside
the aggregate instead. Readability decides; both compile.

### 3.4 Derived boolean flag

```sql
CASE WHEN CHARINDEX('annualreview', LOWER(at.Identifier)) > 0 THEN 'TRUE' ELSE 'FALSE' END
```

**Placement:** model dimension, `type: 'truefalse'`. Do **not** carry `'TRUE'`/`'FALSE'` as text —
that was a limitation of the export format, not a business fact.

### 3.5 Self-join for period comparison

**Signature:** the same table joined to itself on a date offset, or two date-filtered CTEs
subtracted.

**Placement:** **report layer**, via AQL's relative-period primitives. Never a second model.

### 3.6 Running total, rank, percent-of-total

**Placement:** **report layer**, via AQL's declarative primitives (`of_all()` and friends) rather
than window functions. Verify with `validate_aql` before assuming the primitive covers the case.

### 3.7 Correlated `EXISTS` / semi-join

**Placement:** relationship plus a filter. Watch that a semi-join does not become a fan-out join —
`EXISTS` returns parent rows once, a plain join does not.

### 3.8 Timezone shift

`DATEADD(HOUR, -7, GETDATE())` → a model- or dataset-level concern. Confirm whether the warehouse
stores UTC and the report shifts, or the warehouse is already local. Getting this backwards moves
every date boundary by one day for a portion of rows.

---

## 4. Stays in SQL

Only after `validate_aql` confirms it. Record every one in `aql-capability-matrix.md`.

### 4.1 Latest-record-per-key dedup

**Signature (two spellings, one family):**

```sql
ROW_NUMBER() OVER (PARTITION BY k ORDER BY updated_at DESC) AS VR   -- … WHERE VR = 1
```

```sql
SELECT DISTINCT k, FIRST_VALUE(CAST(InsertDateTime AS DATE))
       OVER (PARTITION BY k ORDER BY version) AS completed_date
```

**Placement:** **query model.** This is a grain correction on the source, and it must happen before
the model exposes a grain at all.

```aml
Model latest_metric_values {
  type: 'query'
  label: 'Latest Metric Values'
  description: 'One row per loan adjudication per metric definition — latest version only.'
  data_source_name: '{source}'
  query: @sql
    SELECT * FROM (
      SELECT *, ROW_NUMBER() OVER (
        PARTITION BY LoanAdjudication_Id, TenantIdentifier, MetricDefinition_Identifier
        ORDER BY UpdateDateTime DESC) AS vr
      FROM etl.Metric WHERE Deleted = 0
    ) t WHERE vr = 1;;
}
```

State the corrected grain in the description. That is the whole point of putting it here.

### 4.2 Filters that belong in the model

Two kinds, both true for every consumer:

- **Soft delete** — `WHERE Deleted = 0`. Appears in every CTE. Model filter.
- **Data-quality exclusion** — a hardcoded list of test accounts. Model filter, but it wants to be a
  maintained seed table rather than an inline literal list nobody will update.

```sql
AND (business.LegalName IS NULL
     OR LOWER(business.LegalName) NOT IN ('test', 'abcd', 'blue rocket', …))
```

**Gotcha:** the `IS NULL OR` guard is load-bearing. `NOT IN` drops null rows in SQL. Reproduce the
null handling deliberately, or you lose every row with no legal name.

Contrast with `WHERE la.CreatedDateTime >= @StartDate`, which is **report scope** → a dashboard date
filter, not a model filter.

### 4.3 Range joins, non-equi joins, as-of joins

Relationships are equi-join only. `BETWEEN`, `<`, `>` join predicates and SCD2 as-of joins have no
relationship equivalent. Query model — but check `validate_aql` first; a bounded range sometimes
re-expresses as an equi-join on a derived bucket key.

### 4.4 Recursive CTEs, `PIVOT`/`UNPIVOT`, sessionization

Query model. Genuinely outside AQL. Still log the attempt.

### 4.5 `UNION ALL` of like shapes

**Placement:** one query model with a `source_type` dimension added, **not** N models the report
has to stitch back together. The discriminator is what makes the union queryable afterwards.

---

## 5. Query shape

Classify the outer query before anything else. It changes what the conversion produces.

| Shape | Signature | Consequence |
| --- | --- | --- |
| **Aggregate report** | outer `GROUP BY`, few columns | The aggregates map to metrics directly |
| **Flat detail extract** | no outer `GROUP BY`, many columns, feeds Excel | **Almost no metrics exist in the SQL.** Model the grain, make the columns dimensions |

The flat extract is the common case for "consolidated" and "master" reports, and it breaks the
instinct to look for measures. Do not invent metrics to fill the gap — that means inventing business
definitions, and "approval rate" requires deciding whether an approval-on-appeal counts. List them
as follow-ups instead.

---

## 6. Dialect

Name the source dialect. Record every dialect-specific function and its target mapping.

| T-SQL | Note |
| --- | --- |
| `FORMAT(x, fmt)` | Presentation. Relocate, do not port |
| `EOMONTH(x, n)` | Month arithmetic; a date dimension replaces it |
| `DATENAME(MONTH, x)` | Presentation |
| `DATEPART(WEEKDAY, x)` | **`SET DATEFIRST`-dependent.** Week start silently differs on the target |
| `IIF(c, a, b)` | Two-branch `case()` |
| `ISNULL(a, b)` | `coalesce` — but check whether it is null-handling or blanking (section 2) |
| `STRING_AGG(x, s) WITHIN GROUP (ORDER BY …)` | `agg_text` passthrough; ordering may not survive |
| `DECLARE @Var = …` | Report parameter → dashboard filter |
| `[Bracketed Name]` | `label:` on the dimension |
| `;WITH` | Leading-semicolon idiom, not a construct |

Other dialects get their own table as they arrive. Add them here.
