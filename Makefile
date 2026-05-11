.PHONY: format-lua
format-lua:
	# TODO: stylua ./ がうまく動かないので、find で再帰的に実行する
	find . -name "*.lua" -exec stylua {} +

.PHONY: dump-brew
dump-brew:
	@brew bundle dump --no-vscode --no-go --no-uv --no-cargo --force
