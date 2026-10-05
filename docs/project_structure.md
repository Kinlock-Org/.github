# Kinlock — Project Structure

| | |
|---|---|
| **Status** | Draft v0.3 (worldwide scope; matches `PRD.md`, `ARCHITECTURE.md`, `AGENTS.md` v0.3) |
| **Date** | 2026-10-05 |
| **Purpose** | Where everything lives, who owns it, and which files are safe or dangerous to touch |

Conventions here are the intended defaults. Commands and paths marked *(intended)* don't exist until scaffolded; create them as described instead of inventing alternatives.

---

## 1. Organization and repos

GitHub org: **`kinlock`** (confirm availability; backups `earmarkd`, `sealpaid`).

| Repo | Purpose | Language | Milestone | Wave-ready? |
|---|---|---|---|---|
| `kinlock-contracts` | One Soroban contract (`registry` + `vault` modules), tests, deploy scripts, bindings | Rust | M1 | Yes, but security-sensitive |
| `kinlock-registry` | Public payee JSON, schema, hash-check CI | JSON / TS scripts | M1 | Yes, best beginner source |
| `kinlock-sdk` | TS SDK and the indexer + list API | TypeScript | M2 | Yes |
| `kinlock-app` | Next.js web app | TypeScript | M3 | Yes |
| `kinlock-ramp` | Anchor integration service | TypeScript | M5, **conditional** | Not yet |
| `.github` | Org profile, default community health files, canonical docs | Markdown | M0 | No |

Dependency flow: `contracts` → generated bindings (npm package) → `sdk` → `app`. `registry` is data only. `ramp` does not exist until the M0 anchor spike passes.

Drips Wave note: the program limits repo applications per cycle, so apply the four active repos first and leave `kinlock-ramp` for later.

## 2. Local workspace layout

A plain folder of sibling clones. It is **not** a git repo or monorepo.

```
kinlock/                      # local workspace directory
├── .github/                  # org repo: community files + canonical docs
├── kinlock-contracts/
├── kinlock-registry/
├── kinlock-sdk/
├── kinlock-app/
└── kinlock-ramp/             # only after M0 passes
```

Agents work **inside one repo at a time**. Cross-repo changes are separate PRs, merged in dependency order: contracts → sdk → app.

## 3. Files every repo has

```
<repo>/
├── README.md                 # what it is, quick start, link to docs/
├── ROADMAP.md                # LIVE status of all remaining work; updated in EVERY PR (see §3.1)
├── AGENTS.md                 # copy of the rulebook (identical across repos)
├── CLAUDE.md                 # imports AGENTS.md; Claude Code guidance
├── CONTRIBUTING.md           # repo-specific setup; defers to org-level guide
├── SECURITY.md               # how to report; link to org policy
├── LICENSE                   # decide once, org-wide
├── .gitignore
├── .env.example              # variable names only, never real values
├── .github/
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md      # matches AGENTS.md §7
│   ├── ISSUE_TEMPLATE/               # bug, feature, wave-task
│   └── workflows/                    # per-repo, see §4; every repo includes roadmap-check.yml
└── docs/
    ├── PRD.md                # vendored copy, read-only here
    ├── ARCHITECTURE.md       # vendored copy, read-only here
    ├── ARCHITECTURE_ESSENTIALS.md    # vendored copy, read-only here
    └── adr/                  # NNNN-title.md; see §7
```

### Docs: one source of truth
- **Canonical docs** live in the org `.github` repo under `docs/`.
- Each repo holds a **vendored read-only copy** in `docs/` with a header: `Synced from kinlock/.github. Do not edit here.`
- `scripts/sync-docs.sh` *(intended)* refreshes the copy. A CI job `docs-in-sync` fails if a repo's copy differs from canonical.
- Agents must not edit vendored docs; doc changes go through a PR to the canonical repo (see `AGENTS.md` §11).

### 3.1 `ROADMAP.md`: the one doc that is not read-only

- Lives at each repo's **root** (not in `docs/`), and is **editable in every PR**.
- **Every PR must update it**: row statuses, new rows, a Changelog entry, the date, and the progress counts. This applies to humans and agents, with no "small change" exceptions. Rules are in `AGENTS.md` §12.
- Rows have permanent IDs and an owning repo, so each repo edits only its own rows and copies merge cleanly.
- A maintainer merges the repo copies into the canonical `docs/ROADMAP.md` in the org `.github` repo (`scripts/roadmap-merge`, intended) at least weekly and at every gate.
- CI job `roadmap-check` (every repo) fails a PR whose diff doesn't change `ROADMAP.md` or doesn't add a Changelog entry referencing the PR.
- The PR template has a **Roadmap** section, and the org and repo `CONTRIBUTING.md` must state the rule prominently.
- `ROADMAP.md` is intentionally **not** code-owner-gated: routine updates ride along with the PR they describe.

### Org `.github` repo

```
.github/                      # the repo named ".github"
├── profile/README.md         # org landing page
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md           # org-wide contribution guide
├── SECURITY.md               # vulnerability reporting policy
├── SUPPORT.md
├── docs/
│   ├── PRD.md
│   ├── ARCHITECTURE.md
│   ├── ARCHITECTURE_ESSENTIALS.md
│   ├── project_structure.md  # this file
│   ├── ROADMAP.md            # canonical merged roadmap (see §3.1)
│   └── adr/                  # canonical ADRs
├── scripts/
│   ├── roadmap-progress      # recount statuses and refresh the progress table
│   ├── roadmap-merge         # merge per-repo ROADMAP.md rows into the canonical copy
│   └── sync-docs.sh
└── templates/
    ├── AGENTS.md             # canonical agent rulebook
    ├── CLAUDE.md
    ├── PULL_REQUEST_TEMPLATE.md      # includes the Roadmap section
    └── workflows/roadmap-check.yml   # reusable roadmap-check job
```

## 4. Repo layouts

Legend: `[gen]` generated, never hand-edit · `[sec]` security-sensitive (maintainer review) · `[data]` public data, no personal info

### 4.1 `kinlock-contracts`

```
kinlock-contracts/
├── Cargo.toml                        # workspace
├── rust-toolchain.toml               # pinned toolchain
├── contracts/
│   └── kinlock/
│       ├── Cargo.toml
│       └── src/
│           ├── lib.rs                # [sec] contract entry points, wiring
│           ├── constants.rs          # [sec] MAX_TRANCHES, durations, grace periods
│           ├── types.rs              # [sec] Config, Payee, Lock, Tranche, enums (append-only)
│           ├── errors.rs             # [sec] #[contracterror] enum
│           ├── events.rs             # [sec] event structs, schema_version
│           ├── storage.rs            # [sec] DataKey, read/write helpers, TTL extension
│           ├── registry.rs           # [sec] register_payee, set_status, update_payout
│           ├── vault.rs              # [sec] create_lock, release, refund, decline, bump_lock
│           ├── admin.rs              # [sec] attesters, tokens, pause, caps, upgrade
│           └── test/                 # unit tests (mod test)
│               ├── mod.rs
│               ├── registry_tests.rs
│               ├── create_lock_tests.rs
│               ├── release_tests.rs
│               ├── refund_decline_tests.rs
│               └── auth_tests.rs     # explicit-auth tests, not mock_all_auths only
├── tests/
│   ├── integration.rs                # multi-step flows, C-address accounts, missing trustline
│   ├── properties.rs                 # proptest: invariants from ARCHITECTURE.md §4.6
│   └── budget.rs                     # soroban-budget-assert cost tests
├── bindings/
│   └── typescript/                   # [gen] published as an npm package, consumed by sdk
├── scripts/
│   ├── localnet.sh                   # start Stellar quickstart container
│   ├── deploy.sh                     # [sec] defaults to testnet; mainnet needs flag + confirmation
│   ├── gen-bindings.sh               # stellar contract bindings typescript
│   └── sync-docs.sh
├── deployments/
│   └── testnet.json                  # [gen] written by deploy.sh
├── DEPLOYMENTS.md                    # [gen] from deploy output; don't hand-edit
└── .github/workflows/
    ├── ci.yml                        # fmt, clippy -D warnings, test, build, budget
    ├── bindings.yml                  # publish bindings on tag
    └── docs-in-sync.yml
```

Notes:
- Soroban test snapshot folders (`test_snapshots/`): **gitignore** them to avoid noisy diffs, unless the team decides otherwise.
- One contract crate, several modules. Do not split into two contracts without an ADR.

### 4.2 `kinlock-registry`

```
kinlock-registry/
├── supported-countries.json          # [data][sec] ISO 3166-1 list; change only with counsel sign-off
├── attesters/
│   └── <handle>.json                 # [data] attester identity + countries they may vouch for
├── payees/
│   └── <country>/                    # ISO 3166-1 alpha-2, lowercase (e.g. ng/, ph/, br/)
│       └── <slug>.json               # [data] one file per verified payee
├── schemas/
│   ├── payee.schema.json
│   └── attester.schema.json
├── scripts/
│   ├── hash.ts                       # sorted-key compact JSON → SHA-256 → meta_hash
│   ├── validate.ts                   # schema, canonical formatting, country/currency/attester-scope rules
│   └── check-onchain.ts              # compare meta_hash with on-chain record
├── package.json
├── ATTESTER_CHECKLIST.md             # trustline, XLM float, test release (see PRD REG-6)
└── .github/
    ├── CODEOWNERS                    # attesters own payees in their countries
    └── workflows/
        ├── validate.yml              # schema, formatting, supported country, attester scope, slug uniqueness
        └── onchain-match.yml         # post-registration hash check (scheduled)
```

Public fields only: `slug`, `display_name`, `category` (`School` | `Rent`), `country` (ISO 3166-1 alpha-2), `local_currency` (ISO 4217), `city`, `payout_address`, `attester`, `verified_at`. No personal data or evidence, ever.

CI (off-chain policy, not enforced by the contract) fails a payee whose country isn't in `supported-countries.json`, whose attester isn't authorized for that country, whose directory doesn't match `country`, or whose slug isn't globally unique.

### 4.3 `kinlock-sdk`

```
kinlock-sdk/
├── package.json                      # pnpm workspace root
├── pnpm-workspace.yaml
├── tsconfig.base.json
├── docker-compose.yml                # Postgres for local indexer dev
├── packages/
│   └── sdk/
│       ├── package.json
│       └── src/
│           ├── index.ts              # public API only
│           ├── client.ts             # createLock, release, refund, decline, getLock (chain reads)
│           ├── preflight.ts          # balance, payee status, recent payout change, duplicates, trustline
│           ├── links.ts              # buildClaimLink / parseClaimLink (fragment-carried reference)
│           ├── receipts.ts           # verifyReceipt (tiers 1–2; tier 3 once decided)
│           ├── hash.ts               # ref_hash = sha256(reference || salt)
│           ├── format.ts             # bigint ↔ decimal strings, 7-decimal USDC formatting
│           ├── errors.ts
│           └── __tests__/
├── services/
│   └── indexer/
│       ├── package.json
│       ├── drizzle.config.ts
│       ├── src/
│       │   ├── index.ts              # process entry
│       │   ├── config.ts             # Zod-validated env
│       │   ├── rpc/                  # Soroban RPC client, multi-provider failover
│       │   ├── ingest/               # cursor, poller, gap detection
│       │   ├── handlers/             # one per event type + schema_version
│       │   ├── db/
│       │   │   ├── schema.ts         # chain_events, indexer_cursor, locks, tranches, payees
│       │   │   └── migrations/       # forward-only; never edit applied ones
│       │   └── api/                  # Fastify list API: /locks, /locks/:id, /payees, /health
│       └── test/
│           ├── fixtures/events/      # recorded event JSON, mixed schema_versions
│           └── *.test.ts
└── .github/workflows/
    ├── ci.yml                        # lint, typecheck, test (Postgres service), build
    └── docs-in-sync.yml
```

### 4.4 `kinlock-app`

```
kinlock-app/
├── package.json
├── next.config.ts                    # [sec] security headers / CSP for /claim/*
├── middleware.ts                     # [sec] header rules per route group
├── app/
│   ├── (marketing)/page.tsx          # landing
│   ├── request/                      # payee creates a payment-request link
│   ├── send/                         # sender flow; reads request-link params
│   ├── locks/[id]/                   # sender lock detail (reads chain for actions)
│   ├── claim/[id]/                   # [sec] payee claim; no third-party scripts or analytics
│   ├── payee/                        # payee dashboard (lists via indexer)
│   ├── attester/                     # attester checklist tooling
│   ├── r/[txHash]/[eventIndex]/      # receipt: "Payment to verified payee"
│   └── verify/                       # paste a receipt link or hash
├── components/
│   ├── ui/                           # primitives
│   ├── money/                        # AmountDisplay, AssetLabel (code + issuer), RateNotice
│   └── time/                         # UTC + local time display
├── messages/
│   └── en.json                       # ALL user-visible strings; more languages later = more files
├── lib/
│   ├── sdk.ts                        # single configured SDK instance
│   ├── wallet/                       # wallet-kit abstraction (swappable wallets)
│   ├── claim-links/                  # [sec] browser-only storage + export of claim links
│   ├── rates/                        # RateProvider interface; display-only; USD-only fallback
│   ├── i18n/                         # Intl-based formatting helpers (numbers, currencies, dates)
│   └── config.ts                     # Zod-validated public env
├── e2e/
│   └── happy-path.spec.ts            # request → send → claim → verify (one test)
└── .github/workflows/
    ├── ci.yml
    ├── e2e.yml
    └── docs-in-sync.yml
```

Rules baked into the layout:
- Only `lib/sdk.ts` talks to the contract. Components import from there.
- `claim/` and `lib/claim-links/` handle the URL fragment. Nothing derived from it is logged, stored server-side, or sent to third parties.

### 4.5 `kinlock-ramp` *(conditional: do not create until M0 passes)*

```
kinlock-ramp/
├── src/
│   ├── adapters/                     # one AnchorAdapter per anchor quirk set
│   ├── routes/
│   ├── jobs/                         # anchor status polling
│   └── discovery/                    # SEP-1 stellar.toml + /info checks
└── fixtures/                         # recorded anchor /info responses
```

SEP-24 only at first. No SEP-12, SEP-38, or SEP-45 unless an ADR says otherwise.

## 5. Environment variables

Prefix project variables with `KINLOCK_` where they're not framework-mandated. `.env.example` lists names and safe placeholders only. **Never commit real values.**

| Repo | Variables (illustrative) |
|---|---|
| contracts | `STELLAR_NETWORK` (default `testnet`), `STELLAR_RPC_URL`, `STELLAR_ACCOUNT` (CLI identity *name*, not a key), `KINLOCK_ALLOW_MAINNET` (must be `1` plus human confirmation) |
| indexer | `DATABASE_URL`, `STELLAR_RPC_URLS` (comma-separated, at least two for deployed envs), `STELLAR_NETWORK_PASSPHRASE`, `KINLOCK_CONTRACT_ID`, `PORT` |
| app | `NEXT_PUBLIC_STELLAR_NETWORK`, `NEXT_PUBLIC_RPC_URLS`, `NEXT_PUBLIC_CONTRACT_ID`, `NEXT_PUBLIC_INDEXER_URL`, `NEXT_PUBLIC_USDC_ISSUER` |
| registry | `STELLAR_RPC_URL`, `KINLOCK_CONTRACT_ID` (for the on-chain match check) |

Deploy and signing identities live in the developer's local Stellar CLI keystore or CI secrets, not in repo files.

## 6. Naming conventions

| Thing | Convention |
|---|---|
| Rust | `snake_case` files, functions; `PascalCase` types; `SCREAMING_SNAKE` constants |
| TypeScript files | `kebab-case.ts`; components `PascalCase.tsx` |
| Next.js routes | lowercase, kebab-case segments |
| Registry slugs | lowercase kebab-case, ASCII, **globally unique** (recommended prefix: country code); `payee_id = sha256(slug)` |
| Country and currency codes | ISO 3166-1 alpha-2 (country) and ISO 4217 (currency); never free text |
| UI strings | Keys in `messages/<locale>.json`; never inline in components |
| Branches | `feat/…`, `fix/…`, `docs/…`, `chore/…`, `test/…` |
| Commits | Conventional Commits, scoped (`feat(vault): …`) |
| Database | `snake_case` tables and columns; amounts as `NUMERIC(39,0)` |
| Events | `PascalCase` names, all with `schema_version` |
| ADR files | `docs/adr/NNNN-short-title.md`, zero-padded, never renumbered |

## 7. ADRs

Location: `docs/adr/` in the canonical repo (vendored read-only elsewhere). Format:

```
# NNNN — Title
Status: Proposed | Accepted | Superseded by NNNN
Date:
## Context
## Decision
## Consequences / trade-offs
## Docs updated
```

Write an ADR whenever you change or add an architectural decision, a constant that affects safety, a hard rule, or anything on the deferred list. The 16 v0.2 decisions in `ARCHITECTURE.md` §12 are the starting set.

## 8. Ownership and review

### CODEOWNERS (illustrative; replace handles)

```
# Everything defaults to maintainers
*                                   @kinlock/maintainers

# kinlock-contracts: fund logic needs two maintainers' attention
/contracts/**                       @kinlock/contract-reviewers
/scripts/deploy.sh                  @kinlock/contract-reviewers
/deployments/**                     @kinlock/contract-reviewers

# kinlock-app
/next.config.ts                     @kinlock/maintainers @kinlock/contract-reviewers
/middleware.ts                      @kinlock/maintainers @kinlock/contract-reviewers
/app/claim/**                       @kinlock/maintainers @kinlock/contract-reviewers
/lib/claim-links/**                 @kinlock/maintainers @kinlock/contract-reviewers

# kinlock-registry
/payees/ng/**                        @kinlock/attesters-ng     # example: one team per country
/payees/ph/**                        @kinlock/attesters-ph     # example
/attesters/**                        @kinlock/maintainers
/supported-countries.json            @kinlock/maintainers      # needs counsel sign-off
/schemas/**                          @kinlock/maintainers
```

### Security-sensitive paths (changes need maintainer approval and the `security-sensitive` label)
- All of `contracts/kinlock/src/**` and `tests/properties.rs`
- `scripts/deploy.sh`, `deployments/**`, `DEPLOYMENTS.md`
- `kinlock-app`: `next.config.ts`, `middleware.ts`, `app/claim/**`, `lib/claim-links/**`
- `kinlock-sdk`: `links.ts`, `hash.ts`, `receipts.ts`, `preflight.ts`, indexer `ingest/` and `db/migrations/`
- Any CI workflow or secret configuration

### Safe for broad contribution (good Wave material)
- Registry tooling and validation scripts (not payee data approvals)
- UI components, copy, accessibility, styling in the app
- Docs improvements (via the canonical repo)
- Tests that add coverage without changing behavior
- Indexer fixtures and API documentation

## 9. Labels

Suggested set, applied to all repos:

| Label | Use |
|---|---|
| `security-sensitive` | Touches fund logic, auth, claim links, deploy, CI |
| `good first issue` | Small, self-contained, no security-critical files |
| `wave` | Prepared for Drips Wave contributors (follow the program's current guidelines for scoping and sizing) |
| `area:contract` `area:indexer` `area:sdk` `area:app` `area:registry` | Ownership |
| `blocked:m0` | Waiting on M0 findings |
| `deferred` | On the "do not build" list; keep closed or parked |

## 10. Where does X live?

| If you need to change… | Go to |
|---|---|
| A contract constant (grace period, max tranches, max duration) | `kinlock-contracts/contracts/kinlock/src/constants.rs` + ADR + docs |
| Who can call what | `lib.rs` / `vault.rs` / `registry.rs` / `admin.rs`; **ask first** |
| Event shape | `events.rs` + indexer `handlers/` + docs; **ask first** |
| Claim-link format | `kinlock-sdk/packages/sdk/src/links.ts` (single place) |
| Reference hashing | `kinlock-sdk/packages/sdk/src/hash.ts` |
| Preflight checks | `kinlock-sdk/packages/sdk/src/preflight.ts` |
| Amount formatting | `kinlock-sdk/packages/sdk/src/format.ts` only |
| DB schema | `kinlock-sdk/services/indexer/src/db/schema.ts` + new forward-only migration |
| Receipt page copy | `kinlock-app/app/r/…` (wording rule: "Payment to verified payee") |
| CSP and headers for claim pages | `kinlock-app/next.config.ts`, `middleware.ts` |
| A payee's public profile | `kinlock-registry/payees/<country>/<slug>.json` via attester PR |
| Which countries are supported | `kinlock-registry/supported-countries.json`; **human + counsel sign-off only** |
| Which attester may vouch where | `kinlock-registry/attesters/<handle>.json` |
| Indicative local-currency rate | `kinlock-app/lib/rates/` (display only) |
| Number, currency, date formatting | `kinlock-app/lib/i18n/` (use `Intl`) |
| A user-visible string | `kinlock-app/messages/en.json` |
| Payee JSON hashing | `kinlock-registry/scripts/hash.ts` |
| Deploy to testnet | `kinlock-contracts/scripts/deploy.sh` |
| Architectural decision | New ADR in the canonical `docs/adr/` |
| Status of any task, what's left, what's blocked | `ROADMAP.md` at the repo root (update it in **every** PR) |
| Roadmap progress counts | `scripts/roadmap-progress` (org `.github` repo), or by hand |

## 11. Scaffolding order (maps to milestones)

1. **M0:** create the org and `.github` repo (docs, templates, community files). No code repos yet. Run validation, anchor spike, counsel call.
2. **M1:** scaffold `kinlock-contracts` (workspace, empty modules, test harness, CI, localnet script) and `kinlock-registry` (schema, hash script, CI).
3. **M2:** scaffold `kinlock-sdk` (SDK package, indexer, Postgres compose, fixtures).
4. **M3:** scaffold `kinlock-app` (routes, wallet abstraction, claim-link handling, e2e).
5. **M5, only if M0 found a viable anchor:** create `kinlock-ramp`.

Each scaffold PR should include `ROADMAP.md`, `AGENTS.md`, `CLAUDE.md`, the vendored `docs/`, CI (including `roadmap-check`), `.env.example`, `CODEOWNERS`, and a README with a one-command local start. **Every** PR, scaffold included, updates `ROADMAP.md`.

## 12. Cross-repo local development

1. In `kinlock-contracts`: build, generate bindings, and run the local network (`scripts/localnet.sh`).
2. In `kinlock-sdk`: link the local bindings package (for example with `pnpm link`) and run the indexer against the local network and Postgres.
3. In `kinlock-app`: link the local SDK package and point env vars at the local network and indexer.

Don't commit `link:` or `file:` dependency overrides. Published package versions only on `main`.

## 13. Open structure questions

1. Final license for all repos.
2. Whether canonical docs live in the org `.github` repo (recommended) or in `kinlock-contracts`.
3. Whether to commit Soroban `test_snapshots/` (default here: ignore).
4. npm scope for published packages (`@kinlock/…`) and who holds publish rights.
5. Whether the indexer later becomes its own repo if it outgrows `kinlock-sdk`.
