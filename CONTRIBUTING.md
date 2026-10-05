# Contributing to Kinlock

> **Every pull request, in every repo, must update `ROADMAP.md`.** No exceptions, including docs-only and one-line fixes. If no rows change, add a Changelog entry that says "no row changes." CI (`roadmap-check`) enforces this. Details: `AGENTS.md` §12.

## Before you start
1. Read `docs/ARCHITECTURE_ESSENTIALS.md` in the repo you're working in.
2. Find your task's row in `ROADMAP.md`. Check its **Status** and **Depends on**.
3. For anything beyond a small fix, describe your plan in the issue first.

## Rules that matter most
- Funds go only to the lock's snapshotted payout address or back to the sender.
- Money-moving pages read the chain, never the indexer database.
- The claim-link fragment never leaves the browser.
- No hard-coded country, currency, anchor, or locale anywhere.
- Testnet only.

Full rules: `AGENTS.md`. Contract changes are maintainer-led and labeled `security-sensitive`.

## Workflow
- Branches: `feat/…`, `fix/…`, `docs/…`, `chore/…`, `test/…`. Never commit to `main`.
- Commits: Conventional Commits (`feat(vault): …`).
- PRs use the template, including the **Roadmap** section.

## Docs
Canonical docs live here in `docs/`. Each repo has a read-only copy; change docs with a PR to this repo.
