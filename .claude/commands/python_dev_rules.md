# Python Development Guidelines

This document contains critical information about working with this codebase. Follow these guidelines precisely.

## Core Development Rules

1. パッケージ管理
   - `uv` のみを使用し、`pip` は絶対に使わない
   - インストール方法：`uv add package`
   - ツールの実行：`uv run tool`
   - アップグレード：`uv add --dev package --upgrade-package package`
   - 禁止事項：`uv pip install`、`@latest` 構文の使用

2. コード品質
   - すべてのコードに型ヒントを必須とする
   - パブリックAPIには必ずドキュメンテーション文字列（docstring）を付ける
   - 関数は集中して小さく保つこと
   - 既存のパターンを正確に踏襲すること
   - 行の最大長は88文字まで

3. テスト要件
   - テストフレームワーク：`uv run --frozen pytest`
   - 非同期テストは `asyncio` ではなく `anyio` を使用
   - カバレッジはエッジケースやエラーも含めてテストすること
   - 新機能には必ずテストを追加すること
   - バグ修正にはユニットテストを追加すること
