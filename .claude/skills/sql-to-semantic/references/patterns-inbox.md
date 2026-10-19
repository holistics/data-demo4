# Patterns inbox

Constructs encountered in real customer SQL that `construct-catalog.md` could not classify.

**Append to this file on every run.** An empty inbox after a real customer query means the
classification was lazy, not that the catalog was complete. Without this mechanism the catalog is
frozen at v1 forever.

## What goes here

- A construct with no matching catalog entry.
- A construct that matched an entry but where the prescribed placement turned out to be wrong.
- A dialect function not yet in the catalog's dialect table.
- A query *shape* the catalog's section 5 does not cover.

## What does not

Instances of patterns already catalogued. A fourteenth `row_number()` dedup is not a finding.

## Entry format

```markdown
### {short name}
**Date:** {date} · **Customer / query:** {slug} · **Source dialect:** {dialect}

**SQL:**
```sql
{the minimal snippet that shows the pattern}
```

**Why the catalog missed it:** {no entry / matched entry X but the placement was wrong}
**What was done:** {the placement actually chosen, and whether it was verified}
**Proposed catalog entry:** {section, and a one-line rule — or "needs more instances first"}
```

## Promoting to the catalog

Two instances from different customers, or one instance where the placement is unambiguous, is
enough to promote. Write the catalog entry with a worked before/after — an entry without one is
decoration and will not change what an agent does.

Delete the inbox entry when it is promoted.

---

_No entries yet._
