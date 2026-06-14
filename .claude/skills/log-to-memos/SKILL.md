---
name: log-to-memos
description: スクリーンショットや画像を Memos にアップロードして記録・共有する。画像ファイルパスを受け取り、任意の短い説明文を添えて投稿する。
---

# Log to Memos

スクリーンショットや画像を Memos にアップロードするスキル。

## 手順

`scripts/post_memo.py` を実行して画像を Memos に投稿する:

```bash
uv run --script ~/.claude/skills/log-to-memos/scripts/post_memo.py --image /path/to/image.png "<任意の説明文>"
```

- `--image` で画像ファイルパスを指定する（必須）
- 複数画像を添付する場合は `--image` を複数回指定する
- 末尾に短い説明文（caption）を渡すと本文に含まれる（省略可）
- 画像は Attachment API (`POST /api/v1/attachments`) で先にアップロードされ、メモに自動紐付けされる
- 本文には検索用タグ `#claude-code #screenshot` が自動付与される

## 注意事項

- 説明文は簡潔に。長文は不要。
- 投稿に失敗してもメインの作業を止めないこと
