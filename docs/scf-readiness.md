# Open-source / SCF readiness

Audit of Kinlock against Stellar Community Fund (SCF) standards, done 2026-10-07. Sources: the official [SCF Handbook](https://stellar.gitbook.io/scf-handbook) — [Build Award submission criteria](https://stellar.gitbook.io/scf-handbook/scf-awards/build-award/submission-criteria), [budget & deliverable guidelines](https://stellar.gitbook.io/scf-handbook/scf-awards/build-award/budget-and-deliverable-guidelines), [Public Goods Award official rules](https://stellar.gitbook.io/scf-handbook/supporting-programs/public-goods-award/official-rules), and [Stellar's community guidelines](https://stellar.org/community-guidelines).

**Track fit (read this first):** Kinlock is an end-user payments product (sender locks USDC for a verified school/landlord), not an SDK, indexer, or dev-tooling public good. It doesn't match any of the 8 Public Goods Award categories (SDKs, Data Support, Wallet Support, Developer Experience, Ecosystem Visibility, Infra Monitoring, Governance Tools, Security/Auditing Tools), and Public Goods explicitly excludes projects with a planned revenue model — `M0-15` (sustainability/revenue approach) is still open, so that track may self-disqualify Kinlock anyway. **The Build Award is the right track.** This is my read of the published criteria, not a decision — confirm before applying.

---

## 1. License

**Status: fixed this pass.** Apache-2.0 was already chosen (`ADR-0022`, `DEC-02` resolved) and present in all four active repos, matching the Stellar ecosystem's own convention (Stellar OSS contributions are made under Apache 2.0 per the community guidelines). But every `LICENSE` file still had the template placeholder unfilled: `Copyright [yyyy] [name of copyright owner]`.

Fixed to `Copyright 2026 Kinlock Contributors` in all four repos plus the canonical `.github` repo (the reusable `templates/LICENSE` was left with the placeholder on purpose, since it's meant to be filled in per new repo). **"Kinlock Contributors" is a placeholder convention, not a legal determination** — `DEC-13` (legal entity and jurisdiction) is still open. Swap it for the real entity name once that's resolved; it's a one-line fix per repo when it happens.

## 2. Contributor & community guidelines

| Item | Status |
|---|---|
| `LICENSE` | ✅ present, Apache-2.0, now correctly attributed |
| `CONTRIBUTING.md` | ✅ present (root, per repo) |
| `SECURITY.md` | ✅ present (root, per repo) |
| `CODE_OF_CONDUCT.md` | ✅ satisfied via the org `.github` fallback (GitHub's community-profile check confirms `100%` health on all 4 active repos) |
| PR template | ✅ present |
| Issue templates (bug/feature/wave-task) | ✅ present, but GitHub's community-profile check reported `issue_template: false` because there was no `ISSUE_TEMPLATE/config.yml`. **Fixed this pass** — added `config.yml` (disables blank issues, links to `SECURITY.md` for vulnerability reports) to the canonical templates and all 4 repos |
| `CODEOWNERS` | ⚠️ **file exists but is non-functional.** It references `@Kinlock-Org/maintainers` and `@Kinlock-Org/contract-reviewers` teams that don't exist yet (`F-12`, still `TODO`). GitHub silently ignores CODEOWNERS rules pointing at nonexistent teams — so right now nothing is actually enforcing review on security-sensitive paths. |
| Branch protection | ⚠️ Not configured on any repo (confirmed via API: no protection on `kinlock-contracts`). Required reviews, required status checks, and no-force-push-to-main are all unset. |

**The real gap here is `F-12` (create the `maintainers`/`contract-reviewers`/`attesters` teams).** I'm not creating these myself — team membership is a decision about which actual people hold which role, and that's squarely a human call, not something I should guess. Once you tell me who goes where, I can wire up the teams, make `CODEOWNERS` actually enforce, and turn on branch protection in one pass.

## 3. Roadmap & deliverable clarity

SCF wants deliverables that are **clear, measurable, verifiable, outcome-based** (their own example: "frontend done" = weak; "end-to-end swap flow demo recorded on testnet" = strong), mapped across **three tranches** (MVP → Testnet → Mainnet), with a budget breakdown per deliverable and a verification method for each. `ROADMAP.md`'s ~200 rows are excellent for internal tracking but aren't in that shape — a reviewer shouldn't have to read the whole file. Here's the same information reframed the way SCF scores it:

### Tranche 1 — MVP (contract + SDK + app on testnet)
*Status: substantially complete, not aspirational — see evidence column.*

| Deliverable | Verification |
|---|---|
| Vault entry points (`create_lock`, `release`, `refund`, `decline`, `bump_lock`) implemented with all validations | 103 unit/auth/event/TTL tests + property tests over 512 random sequences, catching 13–14 of 14 injected bugs per 64-case run (`feat/vault`, `test/property-invariants`) |
| Contract deployed to testnet with a multisig admin, test attester, and allowlisted test USDC | Contract `CCSHDQFRYFC3AHV5NE6ULQW6X2CMG5RPANBORDXJGSUD6UKECASJQBRI`, recorded in `DEPLOYMENTS.md`, deployed 2026-10-06 |
| TS bindings generated and published; SDK client (`createLock`/`release`/`refund`/`decline`/`getLock`/`getPayee`), preflight, and receipt verification | SDK `v0.3.0` released as a GitHub Release tarball (`ADR-0026`) |
| App: send flow, claim page with on-chain reference check, decline, lock-detail/refund page | Each merged with its own test suite and CI (`M3-06`, `M3-09`, `M3-10`, `M3-08`) |
| Registry: schema validation, hashing, on-chain match check, testnet fixtures across ≥2 countries | `onchain-match` CI job green on a schedule |

**Remaining for Tranche 1 to fully close:** contract integration test suite (`M1-15`), budget tests (`M1-16`), internal security-checklist review (`M1-22`), indexer (`M2-08..M2-18`, not started), payee dashboard and attester tooling in the app (`M3-11`, `M3-12`).

### Tranche 2 — Testnet pilot
*Status: not started; gated on Tranche 1 closing and the M0 validation gate.*

| Deliverable | Verification |
|---|---|
| ≥2 attesters and 10 payees onboarded via the attester checklist | Checklist completion recorded per payee |
| ≥100 locks run across senders and payees, in ≥2 markets (different regions/currencies), same code | Lock count and per-market breakdown exported from the indexer |
| Pilot metrics measured against `PRD.md` §8.1 targets | Pilot report committed with metrics vs. targets |

### Tranche 3 — Mainnet (capped beta)
*Status: not started; gated on audit and legal review per launch market.*

| Deliverable | Verification |
|---|---|
| External audit complete; all critical/high findings fixed and re-verified | Audit report + remediation summary published |
| Mainnet deploy with caps, verified WASM hash, verified USDC issuer | `DEPLOYMENTS.md` entry generated by the deploy script; hash verified by two people |
| First real-value locks released with no incidents | Incident-free period documented; public status page live |

**Budget:** left blank deliberately. `M0-04` (sender cost model) and `M0-13` (cost targets) are still open, and SCF wants a budget "reasonable and justifiable" against real deliverables — I'm not going to invent dollar figures for that. Fill this in once those rows close.

## 4. Technical integration & feasibility

SCF explicitly wants: a clear Stellar use case, a technical explanation of the integration, a complete architecture outline, and proof the team understands Soroban before applying — plus "your technical architecture must already be complete at the time of application." This is Kinlock's strongest category; the architecture isn't aspirational, it's built and tested:

- **Use case**: locks USDC on Stellar via a Soroban contract so a sender can fund a verified payee (school/landlord) with cryptographic payout-address snapshotting, tranche scheduling, and chain-verifiable receipts — not a superficial integration layered on an off-chain product.
- **Stack**: Rust + `soroban-sdk`, `proptest` + `soroban-budget-assert`; USDC via the Stellar Asset Contract (SEP-41), allowlisted, 7-decimal `i128` amounts; `@stellar/stellar-sdk` + generated TS bindings; Next.js app.
- **Architecture is already complete and documented**: 16 accepted ADRs plus 14 more since the v0.3 scope change (30 total), covering non-custodial design, payout snapshotting, tiered receipt verification, upgrade/timelock strategy, and the country-agnostic core.
- **10 property-tested invariants** enumerated in `ARCHITECTURE_ESSENTIALS.md` §5 (funds exit only to `lock.payout` or `lock.sender`, state-before-transfer, strict boundary semantics, etc.) — exactly the kind of "process diagrams and specifics" SCF reviewers look for, not a sketch.
- **Already live on testnet**, not just designed: real contract ID, real multisig admin, real test USDC.

The one honest caveat: `M0-08` (verify max entry TTL, RPC retention, SAC/trustline failure behavior) is `IN PROGRESS`, not `DONE` — some Soroban network facts are still being confirmed empirically rather than assumed, which is the right way to do it but worth being upfront about in a submission.

## 5. Other categories (from the Build Award criteria)

| Category | Assessment |
|---|---|
| **Build readiness** | Strong. Not a from-scratch proposal — working, tested code exists across all 4 repos today. Ready to continue immediately. |
| **Open source plan** | Satisfied. Contract and all code are already public on GitHub under Apache-2.0; nothing is held back for later open-sourcing. |
| **Ecosystem value & differentiation** | Gap, partially closed this pass. `M0-14` (competitive note) was `TODO`. I could not verify "BarakahPay" (named in the roadmap) as a findable, real product via web search — **flag this to whoever added that name; it may need a correction or a source**. I did find real, citable comparables: [RemitaPay](https://hackquest.io/projects/Remitapay) (USDC-on-Solana school-fee payments converting to NGN), and Circle's Arc-based tuition rail "Remit." Kinlock's differentiation vs. these: Stellar/Soroban (not Solana), payout-address snapshotting + tranche scheduling (not single-shot payment), chain-verifiable "payment to verified payee" receipts, and a registry-driven country-agnostic design meant for multiple markets rather than one corridor. This needs the team's own confirmation before going in a submission — I'm flagging real sources, not asserting this is exhaustive market research. |
| **Product readiness & traction** | Honest gap: no live users yet — Kinlock is pre-pilot (`M0`/`Phase 5` not started). SCF wants either traction or "a clearly validated need identified by a team with relevant experience." Don't claim traction that doesn't exist; the honest framing is the second path, once the M0 interviews (`M0-01/02/03`, materials already drafted, interviews not yet run) produce real validation data. |

---

## What needs a human, not me

1. **Confirm or correct the copyright holder** in `LICENSE` (`DEC-13` is still open; I used "Kinlock Contributors" as a safe interim).
2. **Decide `F-12` team membership** (`maintainers`, `contract-reviewers`, `attesters`) so `CODEOWNERS` and branch protection can actually function.
3. **Verify "BarakahPay"** or supply the real source — I couldn't find it.
4. **Fill in the Tranche budget** once `M0-04`/`M0-13` close.
5. **Decide which award track** (Build Award looks like the fit; confirm before submitting).
