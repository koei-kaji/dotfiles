local lspconfig = require("lspconfig")

lspconfig.yamlls.setup({
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*.gitlab-ci.yml",
				["https://raw.githubusercontent.com/awslabs/goformation/master/schema/sam.schema.json"] = "template.yaml",
			},
		},
	},
})
