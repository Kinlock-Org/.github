#!/usr/bin/env bash
set -euo pipefail

# seed-wave-issues.sh
# Seeds high-impact, scoped Wave contributor issues across Kinlock-Org repositories.
# Adheres strictly to .github/docs/wave-issue-format.md.

echo "Seeding Drips Wave issues across Kinlock-Org..."

# -------------------------------------------------------------
# 1. KINLOCK-CONTRACTS
# -------------------------------------------------------------
echo "Creating issues in Kinlock-Org/kinlock-contracts..."

gh issue create --repo Kinlock-Org/kinlock-contracts \
  --title "test(contract): expand budget assertion tests for release, refund, and decline" \
  --label "wave,area:contract,tier/medium" \
  --body "### Task
Expand the \`soroban-budget-assert\` test suite in \`tests/budget.rs\` to cover \`release\`, \`refund\`, and \`decline\` entry points, ensuring CPU and memory consumption stay within strict limits.

### Context
Today, \`tests/budget.rs\` has budget assertions for \`create_lock\`. We need budget baselines asserted for \`release\`, \`refund\`, and \`decline\` under maximum tranches (12 tranches).
See \`contracts/kinlock/src/constants.rs:7\` (\`MAX_TRANCHES = 12\`).

### Before you start: mandatory context review
1. Read \`docs/ARCHITECTURE_ESSENTIALS.md\` (the core invariants).
2. Read \`AGENTS.md\` (the eleven hard rules, and what is deferred).
3. Read \`ROADMAP.md\` (how roadmap rows are updated).

### Why we need this
Serves roadmap row \`M1-16\` and prevents gas regressions before the mainnet audit candidate freeze.

### Scope
- In scope: \`tests/budget.rs\`.
- Do not touch: \`contracts/kinlock/src/lib.rs\`, storage structures, or constants.

### Suggested implementation
1. Review existing budget test patterns in \`tests/budget.rs\`.
2. Add a test case for \`release\` on the 12th tranche of a 12-tranche lock.
3. Add a test case for \`refund\` after lock expiry.
4. Add a test case for \`decline\` by the payee.
5. Assert CPU and mem budgets using \`assert_budget!\`.

### Edge cases and traps
Do not lower the budget thresholds without recording an explanation. Budget tests must run with release optimization flags.

### Done means
- [ ] Budget assertions exist for \`release\`, \`refund\`, and \`decline\`.
- [ ] \`cargo test --test budget\` passes cleanly.

### Tests
Run \`cargo test --test budget\`.

### Documentation
Update \`ROADMAP.md\` row \`M1-16\`.

### Verify before you open the PR
\`\`\`bash
cargo clippy --all-targets -- -D warnings
cargo test --test budget
\`\`\`

### Opening the pull request
- Ask for issue assignment before starting.
- Commit message: \`test(contract): expand budget assertion tests (closes #<issue>)\`.

### How we review
Reviewed by maintainers. Fails fastest if budget assertions are weakened to make tests pass.

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~1 day · Wave points: 150

### Related roadmap rows
\`M1-16\`
"

gh issue create --repo Kinlock-Org/kinlock-contracts \
  --title "test(contract): verify token removal from allowlist with open active locks" \
  --label "wave,area:contract,tier/medium" \
  --body "### Task
Add a unit test verifying invariant #8: removing an accepted token from the admin allowlist blocks new locks but never prevents releases, declines, or refunds on existing open locks.

### Context
In \`contracts/kinlock/src/vault.rs\`, token checks occur on creation. Invariant #8 states that allowlist removal only affects future locks. We need explicit test coverage confirming this invariant.

### Before you start: mandatory context review
1. Read \`docs/ARCHITECTURE_ESSENTIALS.md\` §5 (Invariants).
2. Read \`AGENTS.md\` §3 (Hard rule 1 & 9).
3. Read \`ROADMAP.md\`.

### Why we need this
Guarantees sender and payee funds cannot be trapped if an admin revokes an asset.

### Scope
- In scope: \`contracts/kinlock/src/test/allowlist_tests.rs\` or \`contracts/kinlock/src/test/vault_tests.rs\`.
- Do not touch: Contract entry point logic or storage keys.

### Suggested implementation
1. Create a lock with an allowlisted token.
2. Call \`remove_token\` via the admin address.
3. Assert that calling \`create_lock\` with this token now reverts with \`TokenNotAllowed\`.
4. Assert that calling \`release\` on the existing open lock succeeds.
5. Assert that calling \`refund\` or \`decline\` on another open lock succeeds.

### Edge cases and traps
Do not modify contract code—this is purely test coverage for existing invariant behavior.

### Done means
- [ ] Test confirms allowlist removal blocks \`create_lock\`.
- [ ] Test confirms existing open lock can still be released.
- [ ] Test confirms existing open lock can still be refunded.

### Tests
\`cargo test --package kinlock\`

### Documentation
Update \`ROADMAP.md\`.

### Verify before you open the PR
\`\`\`bash
cargo fmt --all -- --check
cargo clippy --all-targets -- -D warnings
cargo test --workspace
\`\`\`

### Opening the pull request
Commit: \`test(contract): verify open lock exits after token removal (closes #<issue>)\`.

### How we review
Reviewed by contract reviewers. Fails fastest if tests use \`mock_all_auths\` without explicit auth checks.

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~4 hours · Wave points: 150

### Related roadmap rows
\`M1-19\`
"

# -------------------------------------------------------------
# 2. KINLOCK-SDK
# -------------------------------------------------------------
echo "Creating issues in Kinlock-Org/kinlock-sdk..."

gh issue create --repo Kinlock-Org/kinlock-sdk \
  --title "feat(sdk): exponential backoff and retry helper for transient Soroban RPC rate limits" \
  --label "wave,area:sdk,tier/medium" \
  --body "### Task
Implement an exponential backoff retry utility for HTTP 429 and transient network failures when communicating with Soroban RPC nodes.

### Context
In \`packages/sdk/src/client.ts\`, calls to Horizon and Soroban RPC can encounter rate limits on public testnet infrastructure. We need a clean, zero-dependency retry wrapper with jitter.

### Before you start: mandatory context review
1. Read \`docs/ARCHITECTURE_ESSENTIALS.md\`.
2. Read \`AGENTS.md\` §8.2.
3. Read \`packages/sdk/src/client.ts\`.

### Why we need this
Improves SDK resilience during high network congestion without leaking retry loops into application UI code.

### Scope
- In scope: \`packages/sdk/src/retry.ts\`, \`packages/sdk/src/client.ts\`.
- Do not touch: Cryptographic hashing or URL fragment builders.

### Suggested implementation
1. Create \`packages/sdk/src/retry.ts\` implementing \`withRetry<T>(fn: () => Promise<T>, options?: RetryOptions): Promise<T>\`.
2. Add exponential backoff: base 200ms, max 3 retries, full jitter.
3. Only retry on transient network errors (HTTP 429, 503, connection reset); fail immediately on 400 Bad Request or contract invocation aborts.
4. Export and integrate with SDK RPC requests.

### Edge cases and traps
Never retry state-changing transactions if simulation failed due to contract logic errors (e.g. \`LockExpired\`, \`Unauthorized\`).

### Done means
- [ ] \`withRetry\` utility implemented with tests.
- [ ] Unit tests cover 429 retries, immediate failure on 400, and max attempts exhaustion.
- [ ] 100% test pass in \`packages/sdk\`.

### Tests
Add \`packages/sdk/src/__tests__/retry.test.ts\`.

### Verify before you open the PR
\`\`\`bash
pnpm lint && pnpm typecheck && pnpm test
\`\`\`

### Opening the pull request
Commit: \`feat(sdk): add exponential backoff retry helper for RPC (closes #<issue>)\`.

### How we review
Reviewed by maintainers. Fails if external npm dependencies are introduced.

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~1 day · Wave points: 150

### Related roadmap rows
\`M2-04\`
"

gh issue create --repo Kinlock-Org/kinlock-sdk \
  --title "test(sdk): PGlite in-memory integration tests for concurrent lock events ingestion" \
  --label "wave,area:indexer,tier/medium" \
  --body "### Task
Add integration tests in \`services/indexer\` verifying that duplicate or out-of-order events are ingested idempotently without violating database constraints.

### Context
In \`services/indexer/src/ingest.ts\`, events are ingested into PostgreSQL. The indexer enforces idempotency on \`(tx_hash, event_index)\`. We need concurrent insertion tests using PGlite to prove race conditions do not produce duplicate entries.

### Before you start: mandatory context review
1. Read \`AGENTS.md\` §8.2 (Indexer rules: idempotent writes, chain_events is append-only).
2. Read \`services/indexer/src/schema.ts\`.

### Why we need this
Verifies that indexer event ingestion remains stable under multi-worker environments.

### Scope
- In scope: \`services/indexer/src/__tests__/concurrent-ingest.test.ts\`.
- Do not touch: Migration files or Drizzle schema.

### Suggested implementation
1. Set up in-memory PGlite instance in a new test file.
2. Ingest the same batch of 10 lock events concurrently across 5 parallel promises.
3. Assert that exactly 10 rows exist in \`chain_events\` and no duplicate key error crashes the service.

### Done means
- [ ] Concurrent ingestion test passes with PGlite.
- [ ] No race condition errors.

### Verify before you open the PR
\`\`\`bash
pnpm --filter indexer test
\`\`\`

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~4 hours · Wave points: 150

### Related roadmap rows
\`M2-10\`
"

# -------------------------------------------------------------
# 3. KINLOCK-APP
# -------------------------------------------------------------
echo "Creating issues in Kinlock-Org/kinlock-app..."

gh issue create --repo Kinlock-Org/kinlock-app \
  --title "feat(app): export and display QR code on claim and receipt pages" \
  --label "wave,area:app,tier/medium" \
  --body "### Task
Add an optional QR code display and download button on \`/claim/[id]\` and \`/r/[txHash]/[eventIndex]\` so mobile payees and senders can scan links directly.

### Context
Users on mobile devices benefit from scanning a QR code to transfer claim links between devices. The claim link contains the secret fragment (\`#r=...&s=...\`), so the QR code must be rendered entirely client-side using an SVG/Canvas library with zero server requests.

### Before you start: mandatory context review
1. Read \`AGENTS.md\` Hard Rule 5: The claim-link fragment must never reach a server, log, or third-party service.
2. Read \`app/claim/[id]/ClaimView.tsx\`.

### Why we need this
Improves mobile-to-mobile payment claims without compromising non-custodial privacy.

### Scope
- In scope: A new client-side component \`components/ui/QRCodeDisplay.tsx\`.
- Do not touch: Server components, API routes, or proxy CSP headers.

### Suggested implementation
1. Add a client-side SVG QR code generator (or pure CSS/canvas).
2. Ensure the QR code generator does NOT call an external API (e.g. Google Charts QR API is strictly forbidden).
3. Embed on the claim page behind a \"Show QR Code\" toggle.
4. Verify via Network tab that no requests are made when rendering the QR code.

### Edge cases and traps
Zero network requests. Any component that sends the claim URL to an external image generator violates Hard Rule 5 and will be immediately rejected.

### Done means
- [ ] Pure client-side SVG QR code renders correctly.
- [ ] Network tab confirms zero outbound HTTP requests for QR rendering.
- [ ] Tests verify QR string matches \`window.location.href\`.

### Verify before you open the PR
\`\`\`bash
pnpm lint && pnpm typecheck && pnpm test
\`\`\`

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~1 day · Wave points: 150

### Related roadmap rows
\`M3-07\`, \`M3-13\`
"

gh issue create --repo Kinlock-Org/kinlock-app \
  --title "feat(app): CSV export for payee lock history in /payee dashboard" \
  --label "wave,area:app,tier/medium" \
  --body "### Task
Implement a client-side CSV download button on the \`/payee\` dashboard enabling schools and landlords to export their received locks and release history.

### Context
Roadmap row \`X-05\` requires a CSV export feature that matches the dashboard list view. Payee administrators need this for internal accounting and reconciliation with school tuition or rental records.

### Before you start: mandatory context review
1. Read \`docs/ARCHITECTURE_ESSENTIALS.md\`.
2. Read \`app/payee/PayeeDashboard.tsx\`.
3. Read \`AGENTS.md\` §8.3.

### Why we need this
Fulfills roadmap row \`X-05\` (\`PAY-6\`), a critical pilot requirement for institutional payee accounting.

### Scope
- In scope: \`components/payee/ExportCSVButton.tsx\`, \`lib/csv.ts\`.
- Columns exported: \`lock_id\`, \`sender_address\`, \`total_usdc\`, \`released_usdc\`, \`unlock_date\`, \`status\`, \`created_at\`.

### Suggested implementation
1. Create a helper \`formatLocksToCSV(locks: LockSummary[]): string\` that escapes commas and quotes.
2. Trigger a browser download via \`data:text/csv;charset=utf-8,\` or a Blob URL.
3. Add tests verifying CSV headers, column ordering, and numeric formatting.

### Edge cases and traps
Amounts must be formatted using SDK helpers from BigInt base units. Ensure dates are exported in ISO 8601 UTC.

### Done means
- [ ] Export CSV button renders on \`/payee\` dashboard.
- [ ] Downloaded CSV contains correct columns and matches filtered list.
- [ ] Unit tests pass for CSV generator.

### Verify before you open the PR
\`\`\`bash
pnpm lint && pnpm typecheck && pnpm test
\`\`\`

### Tier and effort
Tier: \`tier/medium\` · Rough effort: ~4 hours · Wave points: 150

### Related roadmap rows
\`X-05\`
"

# -------------------------------------------------------------
# 4. KINLOCK-REGISTRY
# -------------------------------------------------------------
echo "Creating issues in Kinlock-Org/kinlock-registry..."

gh issue create --repo Kinlock-Org/kinlock-registry \
  --title "feat(registry): CLI interactive helper to generate new payee template file" \
  --label "wave,area:registry,tier/trivial" \
  --body "### Task
Create an interactive CLI script \`scripts/new-payee.ts\` that prompts an attester for payee metadata and outputs a schema-compliant JSON file in \`payees/<country>/<slug>.json\`.

### Context
Adding a payee currently requires manually copying a JSON fixture and editing fields. A CLI scaffolding tool will prevent schema violations and slug naming mismatches before PR creation.

### Before you start: mandatory context review
1. Read \`schemas/payee.schema.json\`.
2. Read \`ATTESTER_CHECKLIST.md\`.

### Why we need this
Reduces validation errors in attester pull requests and speeds up payee onboarding during pilot phase.

### Scope
- In scope: \`scripts/new-payee.ts\`.
- Do not touch: \`supported-countries.json\` or existing fixtures.

### Suggested implementation
1. Prompt for \`display_name\`, \`category\` (School|Rent), \`country\`, \`city\`, \`payout_address\`, \`attester\`.
2. Auto-generate the slug from the display name.
3. Validate against \`schemas/payee.schema.json\`.
4. Write file to \`payees/<country>/<slug>.json\`.

### Done means
- [ ] \`pnpm tsx scripts/new-payee.ts\` runs cleanly.
- [ ] Generated file immediately passes \`pnpm validate\`.

### Verify before you open the PR
\`\`\`bash
pnpm lint && pnpm typecheck && pnpm test
\`\`\`

### Tier and effort
Tier: \`tier/trivial\` · Rough effort: ~2 hours · Wave points: 100

### Related roadmap rows
\`M1-24\`
"

gh issue create --repo Kinlock-Org/kinlock-registry \
  --title "test(registry): expand schema validation tests for edge-case Unicode names and accents" \
  --label "wave,area:registry,tier/trivial" \
  --body "### Task
Add unit tests in \`test/schema.test.ts\` verifying that payee \`display_name\` and \`city\` correctly accept international Unicode characters, accents, and non-Latin scripts without failing schema validation.

### Context
Kinlock is worldwide by design. Payees in Latin America, Francophone Africa, or Asia will have accents or non-ASCII characters in school or landlord names (e.g., \"Lycée Français\", \"São Paulo Academy\").

### Before you start: mandatory context review
1. Read \`schemas/payee.schema.json\`.
2. Read \`test/schema.test.ts\`.

### Why we need this
Fulfills Hard Rule 11 (Country-agnostic core) by ensuring schema validation does not reject legitimate international names.

### Scope
- In scope: \`test/schema.test.ts\`.

### Suggested implementation
1. Add test cases with accented French, Spanish, Portuguese, and Vietnamese characters.
2. Verify that \`slug\` remains strictly lowercase ASCII alphanumeric with hyphens, while \`display_name\` and \`city\` accept full Unicode strings.

### Done means
- [ ] Tests added and passing in \`test/schema.test.ts\`.
- [ ] \`pnpm test\` passes.

### Verify before you open the PR
\`\`\`bash
pnpm test
\`\`\`

### Tier and effort
Tier: \`tier/trivial\` · Rough effort: ~1 hour · Wave points: 100

### Related roadmap rows
\`M1-25\`
"

echo "All Wave issues seeded successfully!"
