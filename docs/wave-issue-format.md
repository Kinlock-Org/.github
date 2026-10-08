# Kinlock issue format, tiers and triage

**Why this exists:** Kinlock takes work from external contributors through Drips Wave bounty cycles
and from AI agents under `AGENTS.md`. Both need the same thing: a task whose scope, evidence and
completion test are written down before anyone starts. This document defines the one format every
Kinlock issue uses, the tiers that map to Wave points, and who decides what.

Canonical copy: `Kinlock-Org/.github/docs/wave-issue-format.md`. It is not synced into code repos;
issues and templates reference it by URL.

The format is checked against Drips' [guide for maintainers](https://www.drips.network/blog/posts/creating-meaningful-issues)
— its five principles (real impact, clear context, scope that fits one cycle, direction without
micromanagement, explicit expectations and complexity) map onto **Why we need this**, **Context**,
**Done means** + **Tier and effort**, **Suggested implementation** + **Edge cases and traps**, and
**How we review** + **Opening the pull request**. Re-read it each cycle: if the program's guidance moves,
this document and every seeded issue move with it.

## The format

Every Kinlock issue, however it is filed, uses `.github/ISSUE_TEMPLATE/wave-task.md`'s sections in
this order. A missing section is returned, not merged — do not "improve" the structure per issue.

| Section | What belongs there |
|---|---|
| **Task** | One to three sentences. What to build or fix, and what changes when it is done. |
| **Context** | Today's state with `path:line` evidence for every claim, plus the `ARCHITECTURE.md` sections the task touches. |
| **Before you start: mandatory context review** | Fixed text from the template. Never delete or paraphrase it. |
| **Why we need this** | Which hard rule (§3), gate, pilot need or row **Done when** this serves. "Nicer" is not a reason. |
| **Scope** | In scope, and **Do not touch** — the security-sensitive and generated paths from `docs/project_structure.md` §8. |
| **Suggested implementation** | Numbered, step 1 is always what to read. Must say an alternative is welcome on the issue first. |
| **Edge cases and traps** | The boundaries, failure modes and tempting shortcuts specific to this task — the things a contributor would otherwise have to ask about. |
| **Done means** | Binary checkboxes a reviewer can verify by looking. |
| **Tests** | What to add, what must stay untouched, and the no-weakening rule. |
| **Documentation** | Which doc or ADR moves with the change, or "None" — and if behaviour changes, "None" is wrong. |
| **Verify before you open the PR** | The commands, in the order that works on a clean machine. |
| **Opening the pull request** | Assignment required first, `Closes #<issue>`, the commit-subject example, the §12 roadmap requirement, the PR template, and the evidence the PR must carry. |
| **How we review** | Who reviews, in what order, and what fails review fastest — plus the one thing to look at first for this issue. |
| **Tier and effort** | One tier, a rough estimate for someone new to the codebase, and its Wave point value. |
| **Related roadmap rows** | At least one row ID. Never "none". |
| **Questions** | Answer time and the claim protocol. |

Three rules that make the format worth its cost:

1. **Evidence over assertion.** Context lines cite files and line numbers a contributor can open. If a
   claim cannot be cited, it goes in **Questions** as an open item, not in **Context** as fact.
2. **One issue, one logical change.** A task that touches two purposes is two issues.
3. **The review block is load-bearing.** It is the only place a contributor is told, before coding,
   that the docs outrank their initiative — which is what stops well-meaning agents "fixing" a
   constraint they were supposed to respect.

## Tiers

Tier is set when the issue is filed and drives Wave point value, so it must be defensible. Estimate
for a competent contributor who has **not** seen this codebase before.

| Tier | Shape of the work | Rough effort | Wave complexity · points |
|---|---|---|---|
| `tier/trivial` | Self-contained, one or two adjacent files, no design choice left open. Docs fixes, copy, a small state component, a stale count. | under ~2 hours | Trivial · 100 |
| `tier/medium` | Standard feature or fix inside existing patterns. Several files, judgement required, tests included. One architectural assumption at most. | ~1–3 days | Medium · 150 |
| `tier/high` | Multi-file with real design judgement, unfamiliar toolchain, or a cross-repo parity requirement. Must be claimed before starting. | 3–5 days | High · 200 |

Points are the published mapping in Drips' [guide for maintainers](https://www.drips.network/blog/posts/creating-meaningful-issues);
a cycle can change them, so confirm on `drips.network/wave/stellar` before the Wave opens. Every issue states
its own tier and point value in **Tier and effort** — a contributor should never have to infer what a task is
worth. Complexity is communicated in the issue body and the Wave dashboard, not by inventing extra GitHub
labels: `tier/*` is Kinlock's bookkeeping and nothing else.

Tier rules:

- **Never inflate.** A task that "could" take longer because someone might fight the toolchain is
  `medium` with the friction named in **Questions**, not `high`. When the clock and the judgement point at
  different tiers, say so on the issue — disclose the seam and invite the contributor to challenge it
  before starting, rather than picking a number and hoping nobody notices. Points are a trust signal.
- **Never split to farm points.** Two halves of one change is one issue.
- **Blocked work is not a lower tier.** If a dependency row is not `DONE`, use `blocked:m0` or state
  the blocker in **Related roadmap rows**; a `BLOCKED` row does not become a Wave issue.
- `good first issue` is earned, not decorative: trivial, no judgement call, and the verify commands
  work on a clean machine.

## What never becomes an externally-contributed issue

From `AGENTS.md` §2 and `docs/project_structure.md` §8:

- Anything in a security-sensitive path: contract `src/**`, deploy scripts, `DEPLOYMENTS.md`,
  generated bindings, CI workflows and secret config, the SDK's `links.ts`/`hash.ts`/`receipts.ts`/
  `preflight.ts`, indexer `ingest/**` and `db/migrations/**`, the app's `next.config.ts`,
  `proxy.ts`/`middleware.ts`, `app/claim/**`, `lib/claim-links/**`.
- Anything on the §4 deferred list, and anything in `kinlock-ramp` (conditional repo).
- Anything needing counsel or a named human: `supported-countries.json`, payee or attester approvals,
  multisig and key ceremonies, legal review rows, audit selection.
- Any change to a P0 row's priority, a gate definition, §1 "What 100% readiness means", or an estimate.
- Decisions recorded in the Pending Decisions table (`DEC-…`) — those are adjudicated by a human, and
  the issue that unblocks one is written after the decision, not before it.

The safe categories are the ones `project_structure.md` §8 lists: registry tooling and validation,
UI components/copy/accessibility/styling, docs, additive tests, and indexer fixtures and API docs.

## Filing and triage

Before filing a batch:

1. Confirm each task maps to a row that exists in `ROADMAP.md`. If it does not, add the row first (a
   docs PR), then file the issue against it. Permanent IDs; never renumber or reuse.
2. Confirm the repo's labels include `wave`, `tier/trivial`, `tier/medium`, `tier/high` and the
   `area:*` set.
3. Confirm no issue touches an out-of-scope path above; if the value is real, file it as a maintainer
   task instead, without a tier label.
4. Assign a tier and an effort estimate before publishing, never after (see `W-01` note 3).
5. Read the finished issue as a newcomer who has never seen the repo. You should be able to answer,
   without asking: what exactly to do, what not to touch, where the traps are, what "done" means, which
   commands prove it, what the PR must contain, how it will be reviewed, and what it is worth. If any of
   those needs a question, the issue is not ready — fix it before publishing.

After filing:

- **First response: 2 business days** on any issue comment, including "I'll take this". External
  contributors churn silently; a late answer reads as disinterest.
- Draft PRs are welcome and get feedback, not a merge lecture. Post scope advice before the code exists.
- Review order: correctness against hard rules → tests actually run → diff scope → style. A PR that
  widens its own scope is closed and re-opened, not negotiated.
- `roadmap-check` and `docs-in-sync` are gates, not suggestions. A contributor's PR missing a Changelog
  entry is answered with a link to §12, not by the maintainer editing it for them.
- An issue with no activity for 14 days gets a check-in comment; at 30 days it is un-claimed and, if
  it is not urgent, `help wanted` is removed rather than the issue being closed.
- Anything that surfaces a fund-movement bug stops the queue: it becomes a `security-sensitive`
  maintainer issue immediately, and the contributor is credited in it.

## Per-cycle reminders

Wave limits and points change every cycle. Before applying any repo, re-read
`docs/research/m0-10-wave-rules.md` and re-check the live numbers on `drips.network/wave/stellar` —
per-user and per-org repo limits, and the current budget. KYC is a human prerequisite and cannot be
delegated.

## Rows this document serves

`W-05` (issue sizing guide aligned with program guidelines), `W-01` (Wave application prep),
`W-02` (seeded backlog), `W-06` (review SLAs and triage), `W-08` (limits and KYC tracking).
