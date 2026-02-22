# Codex Repository Template

Codex（CLI/Agent）での開発を前提にした、**最小で実用的なリポジトリテンプレート**です。

## 目的

- 生成AIエージェントが迷いにくいディレクトリ構成を提供する
- 人間レビューしやすい PR 情報と変更履歴を残しやすくする
- まずはドキュメント中心で始めて、必要に応じて言語/フレームワークを追加できる形にする

## 含まれるテンプレート

- `AGENTS.md`: エージェント向け作業ルール（スコープ: リポジトリ全体）
- `.github/pull_request_template.md`: 日本語 PR 記述テンプレート
- `.github/ISSUE_TEMPLATE/*`: 日本語 Issue テンプレート（不具合/機能要望）
- `.github/workflows/ci.yml`: 最低限の整合性チェック CI
- `scripts/check.sh`: ローカルで実行する軽量チェック
- `.editorconfig`: エディタ共通設定
- `.gitignore`: 汎用除外設定

## 使い方

1. このテンプレートをベースに新規リポジトリを作成
2. `README.md` の「プロジェクト固有情報」を追記
3. `AGENTS.md` をプロジェクトに合わせて更新
4. 必要に応じて `scripts/check.sh` にテスト/リンターを追加
5. Issue は `.github/ISSUE_TEMPLATE/` のテンプレートから日本語で起票


## 日本語運用ガイド

- PR は `.github/pull_request_template.md` の項目に沿って日本語で記述
- Issue は「不具合報告 / 機能要望」テンプレートを選んで日本語で記述
- 空 Issue は無効化（`blank_issues_enabled: false`）して、テンプレート利用を促進

## ローカルチェック

```bash
bash scripts/check.sh
```

## プロジェクト固有情報（記入例）

- 概要:
- 想定ユーザー:
- 実行方法:
- テスト方法:
- アーキテクチャメモ:
- 非機能要件（性能/セキュリティ/運用）:

## ライセンス

Apache-2.0
