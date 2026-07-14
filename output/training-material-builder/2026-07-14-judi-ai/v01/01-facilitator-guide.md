# Facilitator Guide — Running the Judi.ai Sessions

For whoever runs the trainings (Niina / the BI lead). The goal of every session is one thing:
**the trainee replaces "wait for a spreadsheet / email the data team" with "open the dashboard."**

## The adoption goal, stated plainly
Adoption = the dashboard becomes the first place a CS person looks when a client asks "how did our
applications do?" Three things get them there, in order:
1. **Confidence in the numbers** → the glossary + the ⓘ info icons.
2. **A question they already care about** → e.g. "how many applications funded last month for this client?"
3. **One self-serve win** → they filter / drill / Ask AI themselves and it works.
Land #3 before the person leaves the room.

## Pre-flight checklist (before every session)
- [ ] Every attendee can log in and lands on the Judi Dataset / their dashboard.
- [ ] Data is recent (check the latest `created_date_time`).
- [ ] The **metrics glossary** (`02-judi-metrics-glossary.md`) is printed / linked.
- [ ] A throwaway **playground** report exists so people can click without fear.
- [ ] The single **"do this tomorrow" task** is decided in advance (see each track).
- [ ] You know which slice is "theirs" (a client/tenant, a month) to filter to live.

## Session structure (60–75 min — works for every track)
| Time | Segment | Purpose |
|---|---|---|
| 0–5 | **The question** | Open with the real weekly/monthly question this role asks. Don't show the tool yet. |
| 5–15 | **Read the dashboard** | Walk the headline KPIs. Use the ⓘ info icons live. Anchor on the role's key metric. |
| 15–25 | **Ask AI** | Type the opening question in plain English. The confidence builder. |
| 25–45 | **Hands-on: explore** | Filter → drill down → view underlying data. Everyone clicks; you narrate. |
| 45–60 | **Make it theirs** | Save a personal view / explore link / build one report. The self-serve win. |
| 60–70 | **Tomorrow** | One concrete task + where to get help. |

## Teaching order of capabilities (low → high friction)
Introduce features in this order — each only makes sense once the previous lands:
1. **Read KPIs + ⓘ info icons** (zero clicks, builds trust)
2. **Ask AI** in plain language (*start nervous users here — it's the front door*)
3. **Filter** (date, client/tenant)
4. **Drill down / view underlying data**
5. **Cross-filter & drill-through**
6. **Explore a report + save to personal workspace**
7. **Share an explore link / report**
8. **Calculations** (period-over-period, % of total) — champions
9. **Delivery** (schedules, alerts, Sheets sync) — set up *with* the data team

CS goes through step 7 (they build). Champions (Niina) go the distance.

## Adoption tactics that actually work
- **Name a champion.** Niina is the natural first champion; train her deep, she becomes peer support.
- **Make Ask AI the front door.** A hesitant CS user who can type "how many applications funded last
  week?" and get a trusted chart is converted. Push this hard.
- **Kill "what does this mean?" emails** by teaching the ⓘ info icons + glossary in the first 10 minutes.
- **Use their own slice.** Filter to a real client and a real month live — generic data doesn't stick.
- **End with a 30-second task,** not homework.
- **Celebrate the first self-built report** (with their OK) as proof it's easy.
- **Office hours, not a one-shot.** A week-4 clinic catches everyone who nodded but didn't click.

## Measuring whether it's working
Track with the admin team; manage adoption like a number:
- Weekly active users per role.
- Ask AI conversations started (low-friction usage signal).
- Personal-workspace reports created (self-service is happening).
- "What does X mean?" emails — should **fall** after the glossary lands.
- Cold test: can a CS user answer "did applications fund up or down vs last month, and why?" in under a minute?

**Target:** *By end of week 4, 80% of CS users open their dashboard weekly and have started ≥1 Ask AI
conversation; ≥1 champion has built and shared a report.*

## Handling the predictable objections
| They say… | You respond… |
|---|---|
| "The numbers don't match what I expected." | Open the glossary. Most surprises are (a) the current-decision fan-out when slicing by an adjudication field, or (b) score averages that exclude no-hits. |
| "I'll break something if I click." | Personal workspace + explore links. Official dashboards are read-only to them; their edits save privately. Demo with the playground report. |
| "I don't have time to learn software." | Lead with Ask AI — no learning required, just type the question. |
| "I already have my spreadsheet / CSV." | Offer scheduled delivery so the numbers come *to* them, always current — then wean onto the live dashboard. |
| "I need a number that isn't there." | That's a request to the data team; repeated requests can become a metric or an AI skill. Capture it, don't lose it. |

## What to escalate to the data team (not solvable in training)
Tell trainees *how* to raise these, so training energy becomes a backlog, not frustration:
scheduled email/Slack delivery, alerts, external shareable links, **new metrics or fields**, the
**multi-tenant / row-level-security** rollout (so each client sees only their own data), and new AI skills.
