#!/usr/bin/env bash
set -euo pipefail

echo "[check] markdown files exist"
test -f README.md

echo "[check] agent instructions exist"
test -f AGENTS.md

echo "[check] workflow exists"
test -f .github/workflows/ci.yml

echo "[check] japanese PR template exists"
test -f .github/pull_request_template.md

echo "[check] japanese issue templates exist"
test -f .github/ISSUE_TEMPLATE/bug_report.md
test -f .github/ISSUE_TEMPLATE/feature_request.md
test -f .github/ISSUE_TEMPLATE/config.yml

echo "[check] issue templates configured (blank issue disabled)"
grep -Eq '^blank_issues_enabled:[[:space:]]*false$' .github/ISSUE_TEMPLATE/config.yml

echo "All lightweight checks passed."
