# Dabble demo database

Privacy-safe, deterministic PostgreSQL data for the AU trading and sport dashboard prototype. It contains no customer names, email addresses, dates of birth or other direct PII. `display_alias` is generated (`Punter 0001`, etc.), and every source-like ID is synthetic.

## Load and check

Run in order against a disposable/local PostgreSQL database:

```sh
psql --set ON_ERROR_STOP=1 --file schema.sql
psql --set ON_ERROR_STOP=1 --file seed.sql
psql --set ON_ERROR_STOP=1 --file assertions.sql
```

Both schema creation and seeding are rerunnable. Seeding truncates only tables in `dabble_demo`. It uses PostgreSQL built-ins and fixed arithmetic based on the approved seed `20260728`; it does not require extensions.

Expected scale: 3,000 users, 24 sports, 66 competitions, 1,200 fixtures, 4,200 markets, 90,000 bets and 198,695 legs. Most multi bets have two to five legs; a small deterministic share covers every leg count through 25 for the supplied margin table. `fact_user_day` has one row per user and settled reporting date, so its row count depends on the deterministic activity distribution.

## Grain and source mapping

| Supplied denormalized table | Normalized destination |
| --- | --- |
| `all_settled_bets` | Bet/user fields → `fact_bet` and `dim_user`; leg financial/result fields → `fact_bet_leg`; sport, competition, fixture and market fields → their respective dimensions. |
| `user_aggs_detailed` | Privacy-safe stable user attributes → `dim_user`; active-day betting totals → `fact_user_day`. PII and non-dashboard operational/acquisition-cost fields are deliberately excluded. |
| `user_aggs_kpi` | Daily stake, payout, boost, BRG, COGS and revenue totals → `fact_user_day`; detailed COGS components remain at bet and leg grain for dashboard drill-down. |

The event hierarchy is `dim_market → dim_fixture → dim_competition → dim_sport`; betting joins `fact_bet_leg → fact_bet → dim_user`. A bet can contain legs from multiple markets, so event keys belong at leg grain.

## Definitions and assumptions

Definitions below are inferred from the supplied extracts/screenshots and must be confirmed before production use:

* `gross_win = cash_stake - cash_payout + rocket_boost` (approved demo label).
* `trading_net_win = gross_win - brg`; the screenshot wording omits boost in its expanded expression, so the approved demo identity takes precedence.
* `trading_net_revenue = trading_net_win - cogs`.
* `combined_stake = cash_stake + bonus_stake` and `combined_payout = cash_payout + bonus_payout`.
* BRG means bet-related generosity; COGS is the sum of NT tax, premium experiences, BetStop levies, GST, POC, Sky Racing, product fee and payment processing fees.
* `dividend` is a deterministic per-leg decimal price. Dashboard Dividend uses a combined-stake-weighted average until Dabble confirms its production aggregation.
* `restricted_stake` is a labelled mock assumption: 20% of combined leg stake on a deterministic subset. It is not a supplied business rule.
* Reporting date is the Australian-session date obtained from `settled_at`; “active” means at least one settled bet on that date.
* Rocket/copy classification is represented by `Copied Rocket Bet`, `Non Copied Rocket Bet` and `Not Rocket`.

`assertions.sql` fails loudly on scale, keys/relationships, money identities, exact leg-to-bet and bet-to-user-day reconciliation, hierarchy, categories, date coverage, PII-safe naming and a negative-profitability sport slice.
