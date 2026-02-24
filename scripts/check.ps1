#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

function Assert-FileExists {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "Required file not found: $Path"
  }
}

function Assert-DirectoryExists {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
    throw "Required directory not found: $Path"
  }
}

function Assert-FileContains {
  param(
    [string]$Path,
    [string]$Text
  )

  Assert-FileExists -Path $Path
  $content = Get-Content -LiteralPath $Path -Raw
  if (-not $content.Contains($Text)) {
    throw "Required text not found in ${Path}: $Text"
  }
}

Write-Output '[check] markdown files exist'
Assert-FileExists -Path 'README.md'

Write-Output '[check] agent instructions exist'
Assert-FileExists -Path 'AGENTS.md'

Write-Output '[check] workflow exists'
Assert-FileExists -Path '.github/workflows/ci.yml'
Assert-FileExists -Path '.github/workflows/branch-name-check.yml'

Write-Output '[check] japanese PR template exists'
Assert-FileExists -Path '.github/pull_request_template.md'

Write-Output '[check] japanese issue templates exist'
Assert-FileExists -Path '.github/ISSUE_TEMPLATE/bug_report.md'
Assert-FileExists -Path '.github/ISSUE_TEMPLATE/feature_request.md'
Assert-FileExists -Path '.github/ISSUE_TEMPLATE/config.yml'

Write-Output '[check] issue templates configured (blank issue disabled)'
$config = (Get-Content -LiteralPath '.github/ISSUE_TEMPLATE/config.yml' -Raw).Replace("`r", '')
if ($config -notmatch '(?m)^blank_issues_enabled:\s*false$') {
  throw 'blank_issues_enabled must be false in .github/ISSUE_TEMPLATE/config.yml'
}

Write-Output '[check] docs directories exist'
Assert-DirectoryExists -Path 'docs'
Assert-DirectoryExists -Path 'docs/requirements'
Assert-DirectoryExists -Path 'docs/design'
Assert-DirectoryExists -Path 'docs/operations'
Assert-DirectoryExists -Path 'docs/adr'
Assert-DirectoryExists -Path 'docs/templates'

Write-Output '[check] docs guidance files exist'
Assert-FileExists -Path 'docs/README.md'
Assert-FileExists -Path 'docs/requirements/README.md'
Assert-FileExists -Path 'docs/design/README.md'
Assert-FileExists -Path 'docs/operations/README.md'
Assert-FileExists -Path 'docs/adr/README.md'

Write-Output '[check] docs templates exist'
Assert-FileExists -Path 'docs/templates/requirements-template.md'
Assert-FileExists -Path 'docs/templates/design-template.md'
Assert-FileExists -Path 'docs/templates/operations-template.md'
Assert-FileExists -Path 'docs/templates/adr-template.md'

Write-Output '[check] PR template includes docs review checklist'
Assert-FileContains -Path '.github/pull_request_template.md' -Text '仕様/挙動変更がある場合、関連docsを更新した'
Assert-FileContains -Path '.github/pull_request_template.md' -Text 'ADRが必要な変更ではADRを追加した'
Assert-FileContains -Path '.github/pull_request_template.md' -Text '更新対象docsのパス'
Assert-FileContains -Path '.github/pull_request_template.md' -Text 'ブランチ名が `type/short-slug` ルールに準拠している'

Write-Output '[check] branch name validator exists'
Assert-FileExists -Path 'scripts/validate-branch-name.sh'

Write-Output 'All lightweight checks passed.'
