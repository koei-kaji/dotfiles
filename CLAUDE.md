# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 一般的なコマンド

### セットアップ
- `./link_dotfiles.sh` - dotfilesをホームディレクトリにシンボリックリンクで配置
- `./clone_tmux_plugins.sh` - tmuxプラグインとcatppuccinテーマをクローン
- `./install_global_npm.sh` - グローバルnpmパッケージをインストール
- `brew bundle` - Brewfileからパッケージをインストール

### フォーマット
- `make format-lua` - Luaファイルをstyluaでフォーマット

## アーキテクチャ

このdotfilesリポジトリは以下の構造になっている：

### シンボリックリンク管理
- `link_dotfiles.sh`が.zshrc、.zshenv、.config、.claude、.aider.conf.ymlをホームディレクトリにリンク
- 既存ファイルは`.pre-manage-dotfiles`拡張子でバックアップされる

### Neovim設定 (.config/nvim/)
- `lua/core/` - コア機能（LSP、フォーマット、リンティング、オプション等）
- `lua/plugins/` - プラグイン設定
- `lua/ui/` - UI関連設定（テーマ、ステータスライン等）
- `lua/editing/` - 編集機能（treesitter、autopairs等）
- `lua/completion/` - 補完機能
- `lua/formatting/` - 言語別フォーマット設定
- `lua/ai/` - AI関連機能（CodeCompanion）
- `after/lsp/` - LSP言語別設定
- `after/ftplugin/` - ファイルタイプ別設定

### Zsh設定 (.config/zsh/)
- `aliases.zsh` - エイリアス定義
- `environment.zsh` - 環境変数
- `options.zsh` - zshオプション
- `plugins.zsh` - プラグイン設定

### その他の設定
- `.config/sheldon/plugins.toml` - zshプラグインマネージャー設定
- `.config/tmux/` - tmux設定とプラグイン
- `.config/wezterm/wezterm.lua` - ターミナル設定
- `Brewfile` - Homebrewパッケージ定義

### テーマ
- CatppuccinテーマをNeovim、tmux、git deltaで統一使用
