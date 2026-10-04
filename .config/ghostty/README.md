# Ghostty + herdr

Ghostty 1.3.1（構文検証・herdr 起動確認済み、キー操作の実機確認は未完了）で、各ウィンドウから
`/opt/homebrew/bin/herdr` を起動する。`~/.config` はこのリポジトリへの
シンボリックリンクなので、Ghostty を起動し直せば反映される。
herdr の設定は `../herdr/config.toml` をそのまま使用する。

WezTerm + herdr 内から Ghostty を開くと、環境変数 `HERDR_ENV` と元の
ペイン情報を引き継ぎ、`nested herdr is disabled by default` で終了することがある。
起動コマンドで `HERDR_ENV`、`HERDR_PANE_ID`、`HERDR_TAB_ID`、
`HERDR_WORKSPACE_ID` を除去して独立したクライアントとして起動する。
ソケット・セッションの指定は維持し、herdr の `allow_nested = false` も維持する。

| キー | 操作 |
| --- | --- |
| Cmd+Shift+N | Ghostty の新規ウィンドウ |
| Cmd+N | herdr の新規ワークスペース |
| Cmd+T | herdr の新規タブ |
| Ctrl+Tab / Ctrl+Shift+Tab | herdr の次 / 前のタブ |
| Cmd+V | 貼り付け |
| Cmd++ / Cmd+- / Cmd+0 | フォント拡大 / 縮小 / リセット |
| Cmd+Ctrl+Enter | フルスクリーン |
| Cmd+Shift+, | Ghostty の設定を再読み込み |

herdr のプレフィックスは引き続き Ctrl+G。分割、ペイン移動、コピー、
ズーム、終了確認、作業ディレクトリの追従は herdr が担当する。
Ghostty の既定キーバインドは解除しているため、コピーは従来どおり
herdr のコピーモード（Ctrl+G → `[`）などを使用する。

## WezTerm との差分

- Catppuccin Mocha、Moralerspace Argon NF 18pt、150×50、余白、背景の
  透明度 0.9 とぼかし 30 を移植。ウィンドウの保存状態より初期サイズを優先する。
- ネイティブの装飾とタブを無効にし、タブは herdr で管理する。
  Ghostty の `window-decoration = none` は macOS の枠と角丸も除去するため、
  WezTerm の `RESIZE` と外観は完全には一致しない。
- WezTerm の Lua によるタイトル中の引用符抽出は移植していない。
  herdr が送信する `[HERDR] {workspace}` をそのまま使用する。
- WezTerm の自動設定再読み込みの代わりに Cmd+Shift+, を使用する。
  起動コマンドやウィンドウ設定の変更後は新規ウィンドウまたは再起動で確認する。
- 背景画像は使用せず、Catppuccin Mocha の背景色を使用する。

cmux も同じ Ghostty 設定を参照するため、cmux を併用する際には起動コマンドや
キーバインドへの影響を確認する。

## 確認

画像表示には herdr の `[terminal] kitty_graphics = true` が必要。
画像を無効にして起動したサーバーでは、設定の再読み込みやクライアントの
detach / 再接続だけでは有効にならない。作業を保存したうえでサーバーを
再起動し、クライアントも接続し直す必要がある。サーバー停止はペイン内の
プロセスを終了するため、実行前に保存と終了の確認を行う。
Yazi の判定は Ghostty + herdr 内で `ya env` の `Drivers.matches` を確認する。
Neovim は image.nvim の Kitty バックエンドを使用する。
Markdown 内画像は `lua/plugins/ui.lua` の `integrations.markdown.enabled = false`
により別途無効になっている。

```sh
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```

起動後、上表の操作、Ctrl+G → `/` の分割、Ctrl+G → `[` のコピー、
日本語入力、ウィンドウを閉じる際の確認を実際に確認する。

仕様: [設定](https://ghostty.org/docs/config/reference)・
[キー操作](https://ghostty.org/docs/config/keybind/reference)
