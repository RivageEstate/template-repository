# ADR-0001 言語導入より先に品質基盤を整備する

- Title: ADR-0001 言語導入より先に品質基盤を整備する
- Status: Accepted
- Date: 2026-02-24
- Owner: Repository Maintainers
- Language: JA/EN

## Context

テンプレート初期段階で実装言語を先に固定すると、後続プロジェクトで再利用しづらくなる。
一方で、ドキュメント運用・CI・レビュー責任が未整備だと、言語に関係なく品質低下が起きやすい。

## Decision

本リポジトリでは、最初に言語非依存の品質基盤を整備する。

- docs構造、要件文書、ADR運用を先に固定する
- CI は軽量チェックと lint を分割ジョブで可視化する
- 貢献ルール、セキュリティ報告手順、レビュー責任範囲を明文化する

今後の言語導入時は、以下を判断基準とする。

- 既存CIとの統合コスト
- 学習コストとチーム保守性
- セキュリティ更新の自動化可否

## Consequences

- テンプレートの再利用性が高まる
- 初期の実装速度はわずかに低下するが、運用の手戻りを削減できる
- 言語導入時に追加ADRで判断理由を継続管理できる

## Alternatives

- 先に特定言語を導入し、その後で運用基盤を整備する
- 言語ごとに別テンプレートを作成する

## 概要 / Summary (JA)

言語選定より前に、品質を支える運用基盤を先に整備する方針を採用する。

## Summary (EN)

The repository adopts a policy to establish language-agnostic quality foundations before choosing an implementation language.

## 結論 / Conclusion (JA)

初期テンプレートは運用標準化を優先し、言語導入は明確な判断基準に基づいて後続で実施する。

## Conclusion (EN)

The template prioritizes operational standardization first, and language adoption is deferred with explicit decision criteria.
