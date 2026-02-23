# Issue起票手順 / Issue Bootstrap Runbook

- Title: テンプレート初期整備Issueの一括作成
- Status: Draft
- Created: 2026-02-23
- Last Updated: 2026-02-23
- Owner: Repository Maintainers
- Language: JA/EN

## 前提 / Preconditions

- GitHub CLI (`gh`) がインストールされている
- `gh auth status` が成功する
- 対象リポジトリに Issue 作成権限がある

## 手順 / Procedure

```powershell
pwsh ./scripts/create-setup-issues.ps1 -DryRun
pwsh ./scripts/create-setup-issues.ps1
```

- `-DryRun` は実際には Issue を作らず、対象の一覧確認のみ行う
- 既存タイトルの Issue がある場合は再作成せず再利用する

## ロールバック / Rollback

- 誤作成した Issue は GitHub UI からクローズする
- タイトルや本文の修正は GitHub UI から編集する

## 監視項目 / Monitoring

- Epic Issue に子Issueのチェックリストが揃っていること
- 既存 Issue の重複が発生していないこと

## 障害時対応 / Incident Response

- `gh issue create` が失敗する場合: `gh auth status` と権限を確認する
- レート制限時: 数分待って再実行する

## 概要 / Summary (JA)

テンプレート初期整備で必要な Issue 群を、再現可能なスクリプトで一括作成する手順です。

## Summary (EN)

This runbook defines a reproducible way to create the full set of bootstrap issues for the template repository.

## 結論 / Conclusion (JA)

Issue 作成作業は `scripts/create-setup-issues.ps1` に一本化し、運用手順を本ドキュメントで管理する。

## Conclusion (EN)

Issue creation is standardized through `scripts/create-setup-issues.ps1`, with operational guidance documented here.
