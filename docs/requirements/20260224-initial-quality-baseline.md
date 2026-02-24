# 初回品質基盤の要件定義 / Initial Quality Baseline Requirements

- Title: 初回品質基盤の要件定義 / Initial Quality Baseline Requirements
- Status: Approved
- Created: 2026-02-24
- Last Updated: 2026-02-24
- Owner: Repository Maintainers
- Language: JA/EN

## 背景 / Background

テンプレート利用開始時に、開発フローと品質担保の最低基準が揃っていないと初期開発が不安定になる。

## 目的 / Objective

言語非依存で再利用できる、最小限かつ実用的な品質基盤を確立する。

## スコープ / Scope

- docs の基本構造と運用ルール
- CI による軽量チェックとlintの自動実行
- 貢献ガイド、セキュリティポリシー、レビュー責任範囲の定義

## 非スコープ / Out of Scope

- 特定言語のビルド/テスト基盤
- プロダクト固有の実装アーキテクチャ

## 受け入れ基準 / Acceptance Criteria

- CI が `template-check` `markdown-lint` `yaml-lint` `shell-lint` を実行できる
- `CONTRIBUTING.md` と `SECURITY.md` が存在し、初見メンバーが手順を辿れる
- `docs/requirements/` と `docs/adr/` に初回ドキュメントが追加され、必須ヘッダ項目が埋まっている

## 制約 / Constraints

- テンプレート段階では依存を増やしすぎない
- 変更は小さく分離し、理由が追跡可能であること

## 概要 / Summary (JA)

初回の品質基盤として、運用ドキュメント、CI、レビュー責任、セキュリティ報告導線を先に整備する。

## Summary (EN)

As an initial quality baseline, operational docs, CI checks, review ownership, and security reporting paths are established first.

## 結論 / Conclusion (JA)

後続の言語導入より前に、再利用可能な運用基盤を固定することで、初期開発の再現性を高める。

## Conclusion (EN)

By fixing reusable operational foundations before language adoption, the template improves repeatability of early development.
