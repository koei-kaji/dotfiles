return {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      pythonPath = ".venv/bin/python",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "off",
      },
    },
  },
}
