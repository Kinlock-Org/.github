# M0-10 — Drips Wave rules review

**Goal:** short note on Drips Wave application limits, KYC, and issue-sizing guidelines, to adjust the Wave plan (`W-01`).
**Done when:** short note; Wave plan adjusted.

## What this covers

Kinlock is Stellar/Soroban-based, so the relevant program is the **Stellar Wave** on Drips Network (`drips.network/wave/stellar`), run with the Stellar Development Fund. Findings below are from the official docs as of 2026-10-07; **reconfirm exact numbers at application time** — Waves run on a recurring (monthly, sometimes weekly-cycle) cadence and the specific limits/budget are configured per cycle, not fixed.

## Mechanics (confirmed, stable across cycles)

- A **Wave** is a recurring bounty cycle: maintainers nominate issues from their repos, contributors apply to work them, progress is tracked via points and a leaderboard, and funds are distributed on-chain at the end of the cycle.
- **Issue sizing**: three complexity tiers set point value — roughly, Trivial (small/self-contained, e.g. typos or minor fixes), Medium (standard feature work or involved bug fixes), and High (complex architecture, refactors, new integrations). Higher tier = more points = larger share of the reward pool.
- **Repo application limits**: Wave Programs can set a **per-user** limit (caps repos one person can apply across all their orgs) and a **per-org** limit (caps repos applied on behalf of one org across all its members). Either, both, or neither may be configured; both reset every new Wave cycle; a rejected application still consumes a slot. The exact numbers are program-specific — one generic page states a default of up to 5 repos per cycle, enforced both per-user and per-org, but **this should be confirmed on the live Stellar Wave page before applying**, not assumed.
- **KYC is required to submit a repo application**, and separately required before any contributor can withdraw earned rewards. This is a regulatory prerequisite, not optional — **a human (the org's own Wave applicant/representative) must complete identity verification**; this is not something that can be done on anyone's behalf.

## Adjustment to the Wave plan (`W-01`)

1. `project_structure.md` already anticipated a repo-application cap ("apply the four active repos first and leave `kinlock-ramp` for later") — this matches the per-org-limit mechanic confirmed above. **Keep that plan**: apply `kinlock-contracts`, `kinlock-sdk`, `kinlock-app`, `kinlock-registry` only; `kinlock-ramp` stays out until it exists (Phase 9 gate).
2. Before submitting any repo application, **complete KYC** for whoever is submitting on the org's behalf — this is a blocking prerequisite, budget time for it.
3. When seeding issues (`W-02`), tag each with a complexity tier (Trivial/Medium/High) up front so sizing is ready the moment a repo is accepted into a cycle — don't wait until acceptance to size issues.
4. Re-check the live per-org/per-user limits and current cycle budget on `drips.network/wave/stellar` immediately before submitting, since both reset and change every cycle.
5. Security-sensitive contract code stays out of Wave scope regardless of limits (`AGENTS.md` §4, `PRD.md` B16) — only seed Wave issues from the "safe for broad contribution" list in `project_structure.md` §8 (registry tooling, UI/copy/accessibility, docs, additive tests, indexer fixtures/API docs).

## Sources

- [Drips Wave — solutions overview](https://www.drips.network/solutions/wave)
- [Drips Wave docs — Participating in a Wave (maintainers)](https://docs.drips.network/wave/maintainers/participating-in-a-wave/)
- [Drips Wave docs — Repo application limits](https://docs.drips.network/wave/maintainers/repo-application-limits)
- [Drips Wave docs — Solving Issues & Earning Rewards (contributors)](https://docs.drips.network/wave/contributors/solving-issues-and-earning-rewards/)
- [Drips Wave docs — Understanding Points & Rewards](https://docs.drips.network/wave/points-and-rewards/)
- [Drips Wave docs — Withdrawing Your Rewards](https://docs.drips.network/wave/withdrawing-rewards/)
- [Drips blog — Creating meaningful issues](https://www.drips.network/blog/posts/creating-meaningful-issues)
- [Drips — Stellar Wave program page](https://www.drips.network/wave/stellar)

## Applied — 2026-10-08 seeding (`W-02`, `W-05`)

Note 3 (tier issues up front) and note 5 (stay inside the safe list) were applied as written. Tier
definitions, the exclusion list and triage SLAs are now `docs/wave-issue-format.md`; the issue body
format is `ISSUE_TEMPLATE/wave-task.md`. Seventeen issues were seeded, all in the §8 safe categories,
each mapped to at least one roadmap row. No issue touches contract `src/**`, the SDK's link/hash/
receipt/preflight modules, indexer `ingest/**` or migrations, `app/claim/**`, `lib/claim-links/**`,
CI workflows, registry data approvals, or `kinlock-ramp`.

| Repo | Issues | Tiers |
|---|---|---|
| `kinlock-contracts` | #27 invariants 5/6/8 harness · #28 integration suite · #29 error and event reference · #30 three doc/code contradictions | high, high, medium, trivial |
| `kinlock-sdk` | #34 mixed `schema_version` fixtures · #35 list API reference + parity test · #36 amount precision boundary · #37 README verified on a clean machine | medium, medium, medium, trivial |
| `kinlock-app` | #37 route loading/error/404 states · #38 contrast tokens · #39 skip link and focus · #40 shared money/time components · #41 first-load JS · #42 `/attester` read-only checks | trivial, trivial, medium, medium, medium, high |
| `kinlock-registry` | #15 validator boundary fixtures · #16 aggregate validation report · #17 attester guide | medium, medium, trivial |

New rows created for work the backlog surfaced: `M1-38`, `M1-39`, `M1-40`, `M1-41`, `M2-20`, `M2-21`,
`M3-27`. Two seeded issues carry a dependency caveat recorded on the issue itself rather than being
withheld: app #42 (`M3-12` depends on `M1-26`, still `IN PROGRESS`) and sdk #34 (`M2-10`/`M2-14` both
`IN PROGRESS` — the issue is the remaining half).

Still open per note 4 and note 2: **re-check the live per-user and per-org limits and cycle budget on
`drips.network/wave/stellar` immediately before applying**, and complete KYC for the human submitting
on the org's behalf. `W-08` tracks the per-cycle numbers; `W-01` stays `IN PROGRESS` until the four
repo applications are submitted.

