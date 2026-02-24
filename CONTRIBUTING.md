# Contributing

このリポジトリは、日本語での Issue / PR 運用を基本とします。

## ブランチ運用

- ブランチ名は `type/short-slug` を使用
- `type`: `feature|fix|chore|docs|refactor|test|ci`
- `short-slug`: 英小文字・数字・ハイフンのみ（先頭末尾ハイフン禁止）
- PR作成時に `Branch Name Check` workflow で自動検証

## 開発フロー

1. Issue を作成し、目的と受け入れ条件を明確化する
2. 作業ブランチを作成して変更する
3. 変更範囲に応じて docs を更新する
4. ローカルチェックを実行する
5. PR をテンプレートに沿って作成する

## ローカルチェック

```bash
bash scripts/check.sh
```

Windows 環境では以下も利用できます。

```powershell
pwsh ./scripts/check.ps1
```

## PR 作法

- `.github/pull_request_template.md` の全項目を埋める
- 仕様/挙動変更がある場合、関連する docs を更新する
- 重要な設計判断を含む場合は `docs/adr/` に ADR を追加する
- CI の全ジョブ成功を確認してからレビュー依頼する

## Issue / PR 言語方針

- Issue は `.github/ISSUE_TEMPLATE/` を利用して日本語で起票
- PR 本文は日本語を基本とし、必要に応じて英語補足を追加
