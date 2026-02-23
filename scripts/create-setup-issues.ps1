param(
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-ExistingIssueByTitle {
  param(
    [string]$Title
  )

  $items = gh issue list --state all --limit 200 --json number,title,url | ConvertFrom-Json
  return $items | Where-Object { $_.title -eq $Title } | Select-Object -First 1
}

function New-IssueIfMissing {
  param(
    [string]$Title,
    [string]$Body
  )

  $existing = Get-ExistingIssueByTitle -Title $Title
  if ($existing) {
    return [pscustomobject]@{
      number = $existing.number
      title = $existing.title
      url = $existing.url
      created = $false
    }
  }

  if ($DryRun) {
    return [pscustomobject]@{
      number = -1
      title = $Title
      url = "(dry-run)"
      created = $false
    }
  }

  $tmp = New-TemporaryFile
  Set-Content -Path $tmp -Value $Body -Encoding utf8
  $null = gh issue create --title $Title --body-file $tmp
  Remove-Item -Path $tmp -Force

  $createdIssue = Get-ExistingIssueByTitle -Title $Title
  if (-not $createdIssue) {
    throw "Issue lookup failed after create: $Title"
  }

  return [pscustomobject]@{
    number = $createdIssue.number
    title = $Title
    url = $createdIssue.url
    created = $true
  }
}

$children = @(
  @{
    title = "chore: .gitattributes を追加して改行コードを統制する"
    body = @'
## 背景
Windows/Unix混在環境で改行コード差異によりシェルスクリプト実行失敗リスクがある。

## 作業内容
- `.gitattributes` を追加
- `* text=auto eol=lf` を設定
- Windows専用拡張子に `eol=crlf` を必要最小限で設定（例: `*.bat`, `*.cmd`）
- 運用ルールをREADMEへ反映（別Issueと連携）

## 受け入れ条件
- `.gitattributes` が存在し、LF/CRLF方針が明文化されている
- 新規追加の `.sh` がLFで管理される
'@
  }
  @{
    title = "fix: scripts/check.sh の改行コードをLFへ統一"
    body = @'
## 背景
`scripts/check.sh` がCRLFのため、Bash実行時に `set -euo pipefail` で失敗する。

## 作業内容
- `scripts/check.sh` をLF化
- Bashで実行して成功確認

## 受け入れ条件
- `bash scripts/check.sh` が成功する
- 同現象が再発しない（.gitattributes整備後）
'@
  }
  @{
    title = "chore: Windows向け scripts/check.ps1 を追加"
    body = @'
## 背景
Windows利用者の初期導線としてPowerShell版チェックが必要。

## 作業内容
- `scripts/check.ps1` を追加
- `check.sh` と同等の存在確認チェックを実装
- 異常時は非0終了コードを返す

## 受け入れ条件
- `pwsh ./scripts/check.ps1` で成功する
- 主要チェック項目が `check.sh` と一致する
'@
  }
  @{
    title = "ci: workflow をジョブ分割して失敗原因を可視化する"
    body = @'
## 背景
現在CIが単一ジョブで、どの観点で失敗したか追跡しづらい。

## 作業内容
- `.github/workflows/ci.yml` を分割
- 例: `template-check`, `markdown-lint`, `yaml-lint`, `shell-lint`
- 各ジョブを独立失敗させる

## 受け入れ条件
- PR時に複数ジョブが実行される
- 失敗時に原因カテゴリが即判別できる
'@
  }
  @{
    title = "ci: markdownlint を導入して docs/README の品質を担保する"
    body = @'
## 背景
ドキュメント中心運用のためMarkdown品質を自動検証する必要がある。

## 作業内容
- markdownlint設定ファイルを追加（必要最小限）
- CIで `*.md` を検証
- 既存文書に違反があれば修正

## 受け入れ条件
- CIでmarkdownlintが実行される
- 現行Markdownが検証を通過する
'@
  }
  @{
    title = "ci: yamllint を導入して GitHub設定の破損を防ぐ"
    body = @'
## 背景
workflow/issue templateのYAML不整合を事前検知したい。

## 作業内容
- yamllint設定を追加
- `.github/**/*.yml` をCI検証対象に追加

## 受け入れ条件
- CIでyamllintが実行される
- `.github/workflows/ci.yml` とIssue template YAMLが通過する
'@
  }
  @{
    title = "ci: shellcheck を導入して scripts/check.sh を静的検証する"
    body = @'
## 背景
bashスクリプトの保守性と移植性を高めるため静的解析が必要。

## 作業内容
- CIにshellcheck実行を追加
- `scripts/*.sh` を対象化
- 指摘対応または妥当な無効化コメントを最小限付与

## 受け入れ条件
- CIでshellcheckが通過する
- `scripts/check.sh` に重大警告が残っていない
'@
  }
  @{
    title = "docs: CONTRIBUTING.md を追加して開発フローを明文化"
    body = @'
## 背景
新規参加者向けの開発ルールがREADMEだけでは不足。

## 作業内容
- `CONTRIBUTING.md` を追加
- ブランチ運用、PR作法、チェック手順を記載
- 日本語運用（Issue/PR）を明記

## 受け入れ条件
- CONTRIBUTINGが存在し、手順が再現可能
- READMEからリンクされる
'@
  }
  @{
    title = "docs: SECURITY.md を追加して脆弱性報告窓口を定義"
    body = @'
## 背景
公開リポジトリ運用で脆弱性報告手段が未定義。

## 作業内容
- `SECURITY.md` を追加
- 報告チャネル、初動SLA目安、公開方針を記載

## 受け入れ条件
- SECURITYポリシーが存在し、外部報告者が行動可能
- 公開Issueではなく私的報告を推奨する導線がある
'@
  }
  @{
    title = "chore: .github/CODEOWNERS を追加してレビュー責任を定義"
    body = @'
## 背景
レビュー責任境界が曖昧だと運用が停滞する。

## 作業内容
- `.github/CODEOWNERS` を追加
- `docs/`, `.github/`, `scripts/` など領域別オーナーを定義

## 受け入れ条件
- CODEOWNERSが有効な形式で存在
- PRで自動レビュアーアサインが機能する
'@
  }
  @{
    title = "chore: Dependabot 設定を追加して依存更新を自動化"
    body = @'
## 背景
GitHub Actions等の依存更新を手動運用すると陳腐化しやすい。

## 作業内容
- `.github/dependabot.yml` を追加
- まず `github-actions` エコシステムを対象化
- 将来言語追加時の拡張方針をコメントで明記

## 受け入れ条件
- Dependabotが設定として有効
- actions更新PRが自動起票される
'@
  }
  @{
    title = "docs: README のプロジェクト固有情報を初期記入"
    body = @'
## 背景
READMEの固有情報欄が空で、実装判断の基準が不足している。

## 作業内容
- 概要、想定ユーザー、実行方法、テスト方法を暫定記入
- 「未定項目」は明示し、決定予定時期を追記

## 受け入れ条件
- READMEの固有情報セクションが空でない
- 初見メンバーがリポジトリ目的を把握できる
'@
  }
  @{
    title = "docs(requirements): 初回要件ドキュメントを作成"
    body = @'
## 背景
docs運用ルールはあるが、実例となる要件文書が未作成。

## 作業内容
- `docs/templates/requirements-template.md` を基に1本作成
- 命名規則 `YYYYMMDD-<slug>.md` を適用
- Acceptance Criteriaを最低3件記載

## 受け入れ条件
- `docs/requirements/` に初回要件が追加されている
- 必須ヘッダ項目が全て埋まっている
'@
  }
  @{
    title = "docs(adr): ADR-0001 を作成して運用方針を固定"
    body = @'
## 背景
「言語非依存で先に品質基盤を整える」判断を履歴化したい。

## 作業内容
- `docs/adr/0001-<slug>.md` を追加
- Context/Decision/Consequences/Alternativesを記載
- 今後の言語導入時の判断基準を明記

## 受け入れ条件
- ADR-0001が追加され、Statusが適切に設定されている
- READMEまたはdocs READMEから参照できる
'@
  }
)

$childResults = @()
foreach ($issue in $children) {
  $childResults += New-IssueIfMissing -Title $issue.title -Body $issue.body
}

$checklist = $childResults | Sort-Object number | ForEach-Object {
  if ($_.number -gt 0) {
    "- [ ] #$($_.number) $($_.title)"
  } else {
    "- [ ] (dry-run) $($_.title)"
  }
}

$epicTitle = "[Epic] テンプレート初期整備（品質基盤・言語非依存）"
$epicBody = @"
## 概要
テンプレートリポジトリを実開発開始可能な状態にするため、品質基盤・運用ガバナンス・初期ドキュメントを段階的に整備する。

## 背景・目的
- 現状はドキュメント雛形中心で、CI/ローカルチェックの実用性が不足している。
- `scripts/check.sh` が改行コード起因で失敗しており、最優先で安定化が必要。
- 将来の言語選定前に、言語非依存の品質ゲートを整える。

## スコープ
- 改行コード統制
- CIの静的チェック強化
- ローカル実行導線の整備
- ガバナンス文書整備
- 依存更新自動化
- 初期requirements/ADR作成

## 非スコープ
- 特定言語（Node/Python等）向けビルド・テスト実装
- アプリケーションコード追加

## 子Issue
$($checklist -join "`n")

## 完了条件
- すべての子Issueが完了
- main向けPRでCIが安定して成功
- ドキュメント運用方針がREADME/ADRに明文化されている
"@

$epic = New-IssueIfMissing -Title $epicTitle -Body $epicBody

"Created/Found child issues:"
$childResults | Sort-Object number | Format-Table number,title,created,url -AutoSize
"Epic:"
$epic | Format-Table number,title,created,url -AutoSize
