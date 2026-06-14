# Python 実行 / パッケージ管理ルール

Python に関する操作は必ず `uv` 経由で行う。`python3` / `python` / `pip` を直接実行しない。

- スクリプト・対話実行: `uv run python ...`（`python3 ...` は禁止）
- 単一ファイルスクリプト実行: `uv run --script <file>.py`
  （PEP 723 でファイル先頭に依存を宣言。プロジェクト不要。`python3 <file>.py` の代替）
- ツール実行: `uv run <tool>`（例: `uv run ruff`, `uv run pytest`）
- パッケージ追加: `uv add <pkg>`
- アップグレード: `uv add --dev <pkg> --upgrade-package <pkg>`
- 禁止: `python3` / `python` の直接実行（settings.json の deny でもブロック済み）、
  `pip` / `uv pip install` / `@latest` 構文
