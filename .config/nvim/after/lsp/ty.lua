return {
  on_attach = function(client, bufnr)
    -- セマンティックハイライト以外を無効化
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.hoverProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.codeActionProvider = nil
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.renameProvider = nil
    -- diagnosticsを無効化
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
  end,
}
