# Kinlock

Lock USDC on Stellar for a verified payee anywhere in the world. Funds can only reach that payee's payout address or go back to the sender, and anyone can verify the receipt on-chain.

Worldwide by design, launched market by market. Testnet only until audit and legal review.

**Live app (testnet):** [kinlock-app.vercel.app](https://kinlock-app.vercel.app) · **Docs:** [kinlock-org.github.io](https://kinlock-org.github.io) · **Indexer:** [health endpoint](https://indexer-production-705a.up.railway.app/health)

## What it does

A sender locks USDC to a payee — a school or a landlord — that a named attester has verified. The lock can carry up to 12 tranches, each with its own unlock date. The payee releases a tranche when it comes due, declines the rest, or the sender gets it back after expiry. Every release, refund, and decline yields a receipt anyone can rebuild from chain data.

**What Kinlock proves:** a specific amount reached a payee a named attester verified, at a specific time, for a specific reference.
**What it does not prove:** that the school credited the student or the landlord applied the rent. Receipts say "Payment to verified payee" and nothing stronger.

## Repos

| Repo | What it is |
|---|---|
| [`kinlock-contracts`](https://github.com/Kinlock-Org/kinlock-contracts) | The Soroban contract (registry + vault in one), 107 unit tests, property tests over invariants 1–10, deploy tooling, generated TS bindings |
| [`kinlock-sdk`](https://github.com/Kinlock-Org/kinlock-sdk) | `@kinlock/sdk` typed client (v0.3.0) and the event indexer + list API, running on testnet |
| [`kinlock-app`](https://github.com/Kinlock-Org/kinlock-app) | Next.js app: request, send, claim, receipts. Core money flows read the chain |
| [`kinlock-registry`](https://github.com/Kinlock-Org/kinlock-registry) | Public payee and attester JSON, schemas, and the CI that binds it to the contract |
| [`Kinlock-Org.github.io`](https://github.com/Kinlock-Org/Kinlock-Org.github.io) | Hosted docs site, and where documentation issues across all repos get filed |
| [`kinlock-ramp`](https://github.com/Kinlock-Org/kinlock-ramp) | **Conditional and empty.** Anchor cash-out integration, created only if the M0 spike finds a viable route |
| [`.github`](https://github.com/Kinlock-Org/.github) | This repo: org profile, community files, canonical docs, 30 ADRs, roadmap tooling |

Dependency flow: `contracts` → generated bindings → `sdk` → `app`. `registry` is data only.

## Where things stand

Building ran ahead of plan: the contract and SDK exist and are deployed to testnet, started at the owner's request before the M0 gate closed. Current work is hardening the contract (integration and budget tests, internal review), finishing the app (payee dashboard, attester tooling, the E2E pass), and clearing Phase 0. The M0 validation — interviews, cost model, per-market cash-out spike, counsel — is still open, and nothing moves to mainnet before an external audit and a per-market legal review.

Row-level status, dependencies, and gates live in [`docs/ROADMAP.md`](https://github.com/Kinlock-Org/.github/blob/main/docs/ROADMAP.md). It is the authoritative record and is current to within a day.

## Principles we don't trade away

- **Chain is truth.** Pages that move money read the chain. Postgres is a mirror for lists.
- **Non-custodial.** No Kinlock service holds a user's keys or funds, and nothing signs for a user.
- **No privileged path to locked funds.** Admin, attesters, pause switches, and upgrades cannot redirect an existing lock. The payout address is snapshotted at creation and immutable.
- **No personal data** on-chain, in the registry, in logs, or on servers. A payment reference lives only in a URL fragment the browser never sends.
- **Country-agnostic core.** No country, currency, anchor, or locale is hard-coded anywhere. Country and local currency are registry data; geography is registry CI and app policy, never contract logic.
- **Build the minimum.** Fees, extra release modes, extra categories, notification systems, and ramps are deferred until evidence justifies them.

## Trust assumptions, stated plainly

- **Attesters decide which payees exist.** A fraudulent attester can divert *future* locks; existing locks can't be redirected. Mitigations: the attester's name on every payee, revocation triggering immediate refund, caps, and a new-payee release delay before mainnet.
- **An admin multisig can upgrade the contract** (a timelock is required before mainnet).
- **The USDC issuer retains freeze and authorization controls.**
- **The ledger is public:** the sender↔payee linkage is visible to anyone.
- **Geography is not enforceable on-chain** — anyone can call the contract directly.

## Contributing

Start with [`docs/ARCHITECTURE_ESSENTIALS.md`](https://github.com/Kinlock-Org/.github/blob/main/docs/ARCHITECTURE_ESSENTIALS.md) (one screen), then [`AGENTS.md`](https://github.com/Kinlock-Org/.github/blob/main/templates/AGENTS.md), which applies to humans as much as to AI agents: what an agent may do freely, what needs a human first, and the eleven hard rules.

- **Every pull request updates `ROADMAP.md`** in the same PR — statuses, new rows, and a Changelog entry. CI (`roadmap-check`) fails the PR if it doesn't. There are no exceptions for small changes.
- Contract entry points, storage layout, events, constants, errors, auth, and anything that changes where funds can go are **ask-first** and labeled `security-sensitive`.
- Good scoped work for contributors is tracked under the `wave` and `good first issue` labels; see each repo's `CONTRIBUTING.md`.
- Security vulnerabilities: report privately per [`SECURITY.md`](https://github.com/Kinlock-Org/.github/blob/main/SECURITY.md), never in a public issue.
- Found a documentation gap anywhere in Kinlock? File it at [`Kinlock-Org.github.io`](https://github.com/Kinlock-Org/Kinlock-Org.github.io/issues/new/choose) with the repo's `area:` label, not as a one-off issue in whichever repo you happened to be reading.

Apache-2.0.
