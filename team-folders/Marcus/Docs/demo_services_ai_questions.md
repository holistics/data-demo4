# Demo Services — AI Question Prep

POC script for the "self-serve AI on a semantic layer" pitch. The point of each scenario is to show what the AI gets *right* because the semantic layer encodes the business rule — and what a naive text-to-SQL agent on the raw tables would get *wrong*.

**Each scenario lists 3 phrasings of the same question.** Run all three against the AI to test that it understands the *intent* regardless of wording.

Dataset: `demo_services` (file: `team-folders/Marcus/Datasets/demo_services.dataset.aml`)

---

## Scenario 1 — Contract vs Service (counts must exclude contracts)

**Phrasings:**
- "How many services did account `ACC-001` buy?"
- "Count the services purchased by `ACC-001`."
- "For `ACC-001`, how many service deliveries are on record?"

**What a naive agent does wrong:** It would `SELECT COUNT(*) FROM services WHERE account_id = ...` and count contract bundling rows along with the real deliveries — the number is inflated.

**Rule encoded by:** `service_count` metric (filters `is_countable_service = true`).

**Expected AQL:**
```aql
explore {
  measures {
    services: service_count,
    contracts: contract_count,
  }
  filters {
    demo_services_accounts.account_id == 'ACC-001',
  }
}
```

---

## Scenario 2 — Services under a contract (parent_id self-join)

**Phrasings:**
- "Show me all services under contract `C-12345`."
- "What deliveries roll up to contract `C-12345`?"
- "List the child services of `C-12345`."

**What a naive agent does wrong:** Without knowing about `parent_id` as a self-join, it can't fetch the child deliveries of a contract.

**Rule encoded by:** `demo_services_services.parent_id > demo_services_services.service_id` self-relationship.

**Expected AQL:**
```aql
explore {
  dimensions {
    service_id: demo_services_services.service_id,
    service_line: demo_services_services.service_line,
    service_date: demo_services_services.service_date,
    delivered_hours: demo_services_services.delivered_hours,
  }
  filters {
    demo_services_services.parent_id == 'C-12345',
  }
}
```

---

## Scenario 3 — Cross-sell eligible services

**Phrasings:**
- "Which services count toward cross-sell credit for account `ACC-077`?"
- "How many of `ACC-077`'s services are eligible for cross-sell?"
- "Show me the cross-sell-qualifying deliveries for `ACC-077`."

**What a naive agent does wrong:** Has to know all four exclusion rules at once — no contracts, no Training, ≥10 hrs delivered, no Omega on Class B — and apply them together. It will get at least one wrong.

**Rule encoded by:** `is_crosssell_eligible` dataset dimension + `crosssell_eligible_count` metric.

**Expected AQL:**
```aql
explore {
  dimensions {
    account_class: demo_services_accounts.account_class,
  }
  measures {
    eligible_services: crosssell_eligible_count,
    all_services: service_count,
  }
  filters {
    demo_services_accounts.account_id == 'ACC-077',
  }
}
```

---

## Scenario 4 — Drill-down: why a specific service is ineligible

**Phrasings:**
- "Why was service `S-99021` not eligible for cross-sell?"
- "Explain the cross-sell ineligibility of `S-99021`."
- "Which rule disqualified `S-99021` from cross-sell credit?"

**What this tests:** the AI exposes each individual gate so the user can see exactly which rule failed.

**Expected AQL:**
```aql
explore {
  dimensions {
    service_id: demo_services_services.service_id,
    service_line: demo_services_services.service_line,
    is_contract: demo_services_services.is_contract,
    is_training: demo_services_services.is_training,
    meets_eligible_hours: demo_services_services.meets_eligible_hours,
    is_omega: demo_services_services.is_omega,
    account_class: demo_services_accounts.account_class,
    is_eligible: demo_services_services.is_crosssell_eligible,
  }
  filters {
    demo_services_services.service_id == 'S-99021',
  }
}
```

---

## Scenario 5 — Actual bonus value (the official number)

**Phrasings:**
- "What's our total bonus value for 2025?"
- "How much bonus did we report YTD?"
- "Give me the actual 2025 bonus number."

**Rule encoded by:** `bonus_actual` metric — applies the pre-2025 rule to pre-2025 rows and the new rule to 2025+ rows, automatically.

**Expected AQL:**
```aql
explore {
  measures {
    bonus: bonus_actual,
  }
  filters {
    demo_services_services.service_date matches @2025,
  }
}
```

---

## Scenario 6 — Counterfactual: "what if we had never switched the rule?"

**Phrasings:**
- "What would the bonus value have been if we'd never switched to the new rule?"
- "Apply the old rule to all years — what does bonus look like?"
- "If we'd kept the Alpha+Beta-only formula in 2025+, what's the bonus by year?"

**What this tests:** the AI reads the rule history embedded in `bonus_actual`'s description and **constructs ad-hoc AQL on the fly** — there is no pre-built counterfactual metric. This is the killer "the AI does the hypothetical math" demo.

**Expected AQL (constructed ad-hoc):**
```aql
explore {
  dimensions {
    year: demo_services_services.service_date | year(),
  }
  measures {
    bonus_if_never_switched:
      sum(demo_services_services.service_value)
      | where(in(demo_services_services.service_line, 'Alpha', 'Beta')),
  }
}
```

---

## Scenario 7 — Counterfactual: "what if we had always used the new rule?"

**Phrasings:**
- "What would the bonus have been if we'd always used the new rule?"
- "Backdate the new rule to all years — show me the bonus by year."
- "Apply Alpha+Beta+Omega across all history — what's the result?"

**Expected AQL (constructed ad-hoc):**
```aql
explore {
  dimensions {
    year: demo_services_services.service_date | year(),
  }
  measures {
    bonus_if_always_new:
      sum(demo_services_services.service_value)
      | where(in(demo_services_services.service_line, 'Alpha', 'Beta', 'Omega')),
  }
}
```

---

## Scenario 8 — Three bonus views side by side (the headline chart)

**Phrasings:**
- "Compare actual bonus to both hypothetical rules by year."
- "Show bonus three ways: actual, never-switched, always-new — by year."
- "How does our reported bonus stack against the two counterfactuals?"

**What this tests:** the AI combines a pre-built metric (`bonus_actual`) with two ad-hoc expressions in a single explore.

**Expected AQL:**
```aql
explore {
  dimensions {
    year: demo_services_services.service_date | year(),
  }
  measures {
    actual: bonus_actual,
    if_never_switched:
      sum(demo_services_services.service_value)
      | where(in(demo_services_services.service_line, 'Alpha', 'Beta')),
    if_always_new:
      sum(demo_services_services.service_value)
      | where(in(demo_services_services.service_line, 'Alpha', 'Beta', 'Omega')),
  }
}
```

**Expected shape:**
- 2023, 2024 → `actual` == `if_never_switched` (pre-switch, no Omega in either).
- 2025+ → `actual` == `if_always_new` (post-switch, Omega counted).
- The two hypotheticals diverge only in years that contain Omega services.

---

## Scenario 9 — "Are there any data-quality issues?" (alert widget)

**Phrasings:**
- "Are there any data-quality issues right now?"
- "Run our standard data-integrity checks."
- "Show me anything that looks off in the services data."

**Rule encoded by:** `dq_total_violations` (sum of all dq_* checks). Healthy state = 0; non-zero lights up the alert widget.

**Expected AQL:**
```aql
explore {
  measures {
    contracts_w_hours: dq_contracts_with_delivered_hours,
    overdelivered: dq_overdelivered_services,
    missing_order: dq_services_missing_order,
    missing_date: dq_services_missing_date,
    total_violations: dq_total_violations,
  }
}
```

---

## Scenario 10 — Drill into a specific DQ flag

**Phrasings:**
- "List the specific services with the over-delivered hours anomaly."
- "Show me each row where delivered hours exceeds the contract amount."
- "Give me the actual records behind the over-delivery flag."

**Expected AQL:**
```aql
explore {
  dimensions {
    service_id: demo_services_services.service_id,
    service_line: demo_services_services.service_line,
    contract_hours: demo_services_services.contract_hours,
    delivered_hours: demo_services_services.delivered_hours,
    account: demo_services_accounts.account_name,
  }
  filters {
    not(demo_services_services.is_contract),
    demo_services_services.delivered_hours > demo_services_services.contract_hours,
  }
}
```

---

## Notes for the demo

- **Bonus value proxy:** the schema has no revenue column, so `service_value` = `delivered_hours` for now. Swap one line in `demo_services_services.model.aml` (`service_value` dimension) when real revenue lands and all bonus answers update automatically.
- **Where the rules live:** single-model rules (`is_training`, `is_omega`, `meets_eligible_hours`, `bonus_rule_era`, `service_value`) in `demo_services_services.model.aml`. Cross-model rules (`is_crosssell_eligible` — needs `account_class`) in `demo_services.dataset.aml`.
- **Why counterfactuals aren't metrics:** analysts can't reasonably pre-build a metric for every hypothetical. The semantic layer captures the *rule and its history* (in `bonus_actual`'s description); the AI does the hypothetical math on top. **This is the pitch.**
- **Why phrasing variations matter:** customers will not phrase questions the way you wrote them. Three phrasings per scenario surfaces whether the AI catches intent or just keyword-matches.
