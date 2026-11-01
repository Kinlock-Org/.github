#!/usr/bin/env bash
set -euo pipefail

echo "Seeding additional Wave issues..."

# 1. KINLOCK-CONTRACTS
gh issue create --repo Kinlock-Org/kinlock-contracts \
  --title "test(contract): boundary timestamp tests for exact unlock_at and expires_at ledger times" \
  --label "wave,area:contract,tier/trivial" \
  --body "### Task
Add unit tests verifying edge-case timestamp boundary conditions in \`contracts/kinlock/src/test/\`: \`now == unlock_at\`, \`now == expires_at\`, and \`now == expires_at - 1\`.

### Context
Hard rule 8 states boundary semantics are fixed: release only if \`unlock_at <= now < expires_at\`; refund only if \`now >= expires_at\`. We need explicit unit tests asserting that at \`now == expires_at - 1\`, release succeeds and refund fails, and at \`now == expires_at\`, release fails and refund succeeds.

### Before you start: mandatory context review
1. Read \`docs/ARCHITECTURE_ESSENTIALS.md\` §5.
2. Read \`contracts/kinlock/src/vault.rs\`.

### Why we need this
Proves that no off-by-one second discrepancy exists on lock release or refund windows.

### Scope
- In scope: \`contracts/kinlock/src/test/vault_tests.rs\`.
- Do not touch: \`vault.rs\` contract logic.

### Suggested implementation
1. Set up a lock with \`unlock_at = 1000\`, \`expires_at = 2000\`.
2. Advance ledger timestamp to 1999: verify \`release\` succeeds.
3. Advance ledger timestamp to 2000: verify \`release\` fails with \`LockExpired\`, and \`refund\` succeeds.

### Done means
- [ ] Boundary tests added and passing.
- [ ] \`cargo test --package kinlock\` is green.

### Verify before you open the PR
\`\`\`bash
cargo test --package kinlock
\`\`\`

### Tier and effort
Tier: \`tier/trivial\` · Effort: ~1 hour · Points: 100

### Related roadmap rows
\`M1-07\`
"

gh issue create --repo Kinlock-Org/kinlock-contracts \
  --title "docs(contract): document storage footprint and TTL math for max lock duration" \
  --label "documentation,wave,area:contract,tier/trivial" \
  --body "### Task
Document the Soroban storage footprint per lock and the TTL safety margin calculation that sets \`MAX_LOCK_DURATION_SECS = 149 days\` in \`contracts/kinlock/src/constants.rs\`.

### Context
In ADR-0020 and \`contracts/kinlock/src/constants.rs:13\`, max lock duration is set to 149 days so that \`lock duration + 30-day TTL grace\` fits within the Stellar network's maximum entry TTL (≈ 6 months). A technical explainer needs to be added to the contract docs.

### Before you start: mandatory context review
1. Read \`docs/adr/0020-max-lock-duration.md\`.
2. Read \`contracts/kinlock/src/constants.rs\`.

### Scope
- In scope: \`contracts/kinlock/README.md\` or \`docs/storage-footprint.md\`.

### Done means
- [ ] Documentation includes byte breakdown of \`Lock\` struct and TTL extension formula.
- [ ] Explains why permissionless \`bump_lock\` exists.

### Tier and effort
Tier: \`tier/trivial\` · Effort: ~1 hour · Points: 100

### Related roadmap rows
\`M0-08\`
"

# 2. KINLOCK-SDK
gh issue create --repo Kinlock-Org/kinlock-sdk \
  --title "test(sdk): Zod boundary fuzzing for malformed and invalid Stellar addresses" \
  --label "wave,area:sdk,tier/trivial" \
  --body "### Task
Expand unit test coverage in \`packages/sdk/src/__tests__/preflight.test.ts\` to fuzz \`Address\` validation using various malformed Stellar StrKeys.

### Context
In \`packages/sdk/src/preflight.ts:203\`, addresses are validated with StrKey. We need comprehensive test cases verifying that invalid checksums, mixed case, truncated keys, and unsupported key types (e.g. M-addresses or S-secret keys) fail with \`INVALID_INPUT\`.

### Scope
- In scope: \`packages/sdk/src/__tests__/preflight.test.ts\`.

### Done means
- [ ] Unit tests added covering invalid checksums, prefix mutations, and invalid lengths.
- [ ] \`pnpm test\` passes.

### Tier and effort
Tier: \`tier/trivial\` · Effort: ~1 hour · Points: 100

### Related roadmap rows
\`M2-05\`
"

gh issue create --repo Kinlock-Org/kinlock-sdk \
  --title "feat(indexer): backfill command to replay chain events from deployment block" \
  --label "wave,area:indexer,tier/high" \
  --body "### Task
Implement an indexer CLI script \`services/indexer/src/cli/backfill.ts\` that replays Soroban events from contract creation ledger to present without duplicating rows.

### Context
Roadmap row \`H-20\` requires disaster recovery verification: the ability to reconstruct PostgreSQL state from chain if the database is wiped.

### Scope
- In scope: \`services/indexer/src/cli/backfill.ts\`.
- Do not touch: Migration files or HTTP route handlers.

### Done means
- [ ] CLI command accepts \`--start-ledger\` and \`--batch-size\`.
- [ ] Tested against local PGlite database: reconstructs events matching chain.

### Tier and effort
Tier: \`tier/high\` · Effort: ~3 days · Points: 200

### Related roadmap rows
\`H-20\`, \`M2-16\`
"

# 3. KINLOCK-APP
gh issue create --repo Kinlock-Org/kinlock-app \
  --title "perf(app): mobile viewport audit and touch target minimum sizing" \
  --label "accessibility,wave,area:app,tier/medium" \
  --body "### Task
Audit and update interactive buttons and input touch targets across \`app/send/\`, \`app/claim/\`, and \`app/request/\` to guarantee a minimum 44x44px clickable area on mobile viewports.

### Context
Roadmap row \`M3-18\` and \`M3-17\` require accessibility and mobile optimization for emerging market smartphone users on small viewports.

### Scope
- In scope: Tailwind utility adjustments on button, input, and selector elements.
- Verify: WCAG 2.1 Success Criterion 2.5.5 (Target Size).

### Done means
- [ ] All interactive elements meet 44x44px minimum touch target size.
- [ ] Lighthouse mobile accessibility score is 100.

### Tier and effort
Tier: \`tier/medium\` · Effort: ~1 day · Points: 150

### Related roadmap rows
\`M3-17\`, \`M3-18\`
"

gh issue create --repo Kinlock-Org/kinlock-app \
  --title "test(app): unit tests for wallet disconnection and rejected transaction states" \
  --label "wave,area:app,tier/medium" \
  --body "### Task
Add Vitest tests in \`lib/wallet/__tests__/\` simulating user wallet rejection, wallet extension lock state, and insufficient XLM balance.

### Context
When a user rejects a transaction in Freighter or Lobstr, the app must show clear recovery guidance per \`M3-21\` rather than an unhandled promise rejection.

### Scope
- In scope: \`lib/wallet/__tests__/wallet-errors.test.ts\`.

### Done means
- [ ] Tests simulate rejection error codes from Stellar Wallets Kit.
- [ ] Verify UI displays user-friendly error copy from \`messages/en.json\`.

### Tier and effort
Tier: \`tier/medium\` · Effort: ~1 day · Points: 150

### Related roadmap rows
\`M3-02\`, \`M3-21\`
"

# 4. KINLOCK-REGISTRY
gh issue create --repo Kinlock-Org/kinlock-registry \
  --title "feat(registry): automated check for attester country permissions in CI" \
  --label "wave,area:registry,tier/medium" \
  --body "### Task
Add a validation check script in \`scripts/check-attester-countries.ts\` and hook it to \`validate.yml\` to ensure no payee file references an attester who is not authorized for that country.

### Context
Each attester has an authorized country roster in \`attesters/<handle>.json\`. A payee in \`payees/ng/<slug>.json\` must be vouched for by an attester whose file includes \`\"NG\"\`.

### Scope
- In scope: \`scripts/check-attester-countries.ts\`, \`.github/workflows/validate.yml\`.

### Done means
- [ ] Script flags mismatched attester-country pairs with clear error output.
- [ ] CI runs this check on every pull request.

### Tier and effort
Tier: \`tier/medium\` · Effort: ~4 hours · Points: 150

### Related roadmap rows
\`M1-29\`
"

gh issue create --repo Kinlock-Org/kinlock-registry \
  --title "docs(registry): step-by-step attester key rotation guide and verification" \
  --label "documentation,wave,area:registry,tier/trivial" \
  --body "### Task
Document the procedural steps for an attester to rotate their Stellar signing key and update their registry record in \`ATTESTER_CHECKLIST.md\`.

### Context
If an attester's key is suspected of compromise, the attester must rotate keys and update their public entry. A clear runbook ensures this can be executed cleanly.

### Scope
- In scope: \`ATTESTER_CHECKLIST.md\`.

### Done means
- [ ] Key rotation procedure documented with verification command.

### Tier and effort
Tier: \`tier/trivial\` · Effort: ~1 hour · Points: 100

### Related roadmap rows
\`M1-28\`
"

echo "Additional Wave issues created successfully!"
