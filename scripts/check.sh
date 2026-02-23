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

echo "[check] docs directories exist"
test -d docs
test -d docs/requirements
test -d docs/design
test -d docs/operations
test -d docs/adr
test -d docs/templates

echo "[check] docs guidance files exist"
test -f docs/README.md
test -f docs/requirements/README.md
test -f docs/design/README.md
test -f docs/operations/README.md
test -f docs/adr/README.md

echo "[check] docs templates exist"
test -f docs/templates/requirements-template.md
test -f docs/templates/design-template.md
test -f docs/templates/operations-template.md
test -f docs/templates/adr-template.md

echo "[check] PR template includes docs review checklist"
grep -Fq '仕様/挙動変更がある場合、関連docsを更新した' .github/pull_request_template.md
grep -Fq 'ADRが必要な変更ではADRを追加した' .github/pull_request_template.md
grep -Fq '更新対象docsのパス' .github/pull_request_template.md

echo "All lightweight checks passed."
