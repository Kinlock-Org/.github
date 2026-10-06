#!/usr/bin/env bash
# Copy canonical docs into a code repo's docs/ (read-only copies with a header), and the
# agent rulebooks into its root. ROADMAP.md is NOT synced: each repo edits its own copy.
#
#   scripts/sync-docs.sh <repo-dir>...          write copies
#   scripts/sync-docs.sh --check <repo-dir>...  exit 1 if any copy differs
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
HEADER='> Synced from Kinlock-Org/.github. Do not edit here.'
DOCS=(PRD.md ARCHITECTURE.md ARCHITECTURE_ESSENTIALS.md)

check=0
if [[ "${1:-}" == "--check" ]]; then check=1; shift; fi
[[ $# -gt 0 ]] || { echo "usage: $0 [--check] <repo-dir>..." >&2; exit 2; }

render_doc() { printf '%s\n\n' "$HEADER"; cat "$1"; }

status=0
compare_or_write() { # <expected-content-file> <target>
  if [[ $check -eq 1 ]]; then
    if ! cmp -s "$1" "$2"; then echo "out of sync: $2" >&2; status=1; fi
  else
    mkdir -p "$(dirname "$2")"; cp "$1" "$2"
  fi
}

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
for repo in "$@"; do
  for doc in "${DOCS[@]}"; do
    render_doc "$HERE/docs/$doc" > "$tmp"
    compare_or_write "$tmp" "$repo/docs/$doc"
  done
  for adr in "$HERE"/docs/adr/*.md; do
    render_doc "$adr" > "$tmp"
    compare_or_write "$tmp" "$repo/docs/adr/$(basename "$adr")"
  done
  for rulebook in AGENTS.md CLAUDE.md; do
    compare_or_write "$HERE/templates/$rulebook" "$repo/$rulebook"
  done
  # ADRs the repo has but the canonical copy doesn't are drift too.
  if [[ $check -eq 1 && -d "$repo/docs/adr" ]]; then
    for adr in "$repo"/docs/adr/*.md; do
      [[ -f "$HERE/docs/adr/$(basename "$adr")" ]] || { echo "not in canonical docs: $adr" >&2; status=1; }
    done
  fi
done
exit $status
