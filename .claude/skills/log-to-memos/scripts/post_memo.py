# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "httpx",
# ]
# ///
"""画像/スクショを Memos に投稿するスクリプト.

画像を Attachment API でアップロードし、メモに紐付けて投稿する。
Usage: uv run --script post_memo.py --image <path> [--image <path> ...] ["<caption>"]
"""

import base64
import mimetypes
import os
import sys
from pathlib import Path

import httpx

MEMOS_HOST = "http://localhost:5230"


def parse_args(argv: list[str]) -> tuple[list[str], str]:
    """引数をパースして (image_paths, caption) を返す."""
    image_paths: list[str] = []
    caption = ""
    i = 0
    while i < len(argv):
        if argv[i] == "--image" and i + 1 < len(argv):
            image_paths.append(argv[i + 1])
            i += 2
        else:
            caption = argv[i]
            i += 1
    return image_paths, caption


def upload_attachment(client: httpx.Client, token: str, image_path: str) -> str:
    """画像を Attachment API でアップロードし、name を返す."""
    path = Path(image_path)
    content_b64 = base64.standard_b64encode(path.read_bytes()).decode()
    mime_type = mimetypes.guess_type(path.name)[0] or "application/octet-stream"

    response = client.post(
        f"{MEMOS_HOST}/api/v1/attachments",
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        json={
            "filename": path.name,
            "type": mime_type,
            "content": content_b64,
        },
        timeout=30,
    )
    response.raise_for_status()
    return response.json()["name"]


def build_content(caption: str) -> str:
    """メモ本文を構成する（caption + 検索用タグ）."""
    parts = []
    if caption:
        parts.append(caption)
    parts.append("#claude-code #screenshot")
    return "\n\n".join(parts)


def main() -> None:
    token = os.environ.get("MEMOS_TOKEN")
    if not token:
        print("Error: MEMOS_TOKEN is not set", file=sys.stderr)
        sys.exit(1)

    image_paths, caption = parse_args(sys.argv[1:])
    if not image_paths:
        print("Error: --image is required", file=sys.stderr)
        sys.exit(1)

    content = build_content(caption)

    with httpx.Client() as client:
        # 画像をアップロード
        attachment_names: list[str] = []
        for image_path in image_paths:
            try:
                name = upload_attachment(client, token, image_path)
                attachment_names.append(name)
                print(f"Uploaded attachment: {name}")
            except Exception as e:
                print(f"Warning: failed to upload {image_path}: {e}", file=sys.stderr)

        if not attachment_names:
            print("Error: no image was uploaded", file=sys.stderr)
            sys.exit(1)

        # メモを作成
        response = client.post(
            f"{MEMOS_HOST}/api/v1/memos",
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json",
            },
            json={
                "content": content,
                "attachments": [{"name": name} for name in attachment_names],
            },
            timeout=10,
        )

    if response.is_success:
        print(f"Posted to Memos (HTTP {response.status_code})")
    else:
        print(
            f"Failed to post to Memos (HTTP {response.status_code}): {response.text}",
            file=sys.stderr,
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
