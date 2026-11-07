return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			-- Know the Neovim runtime, so vim.* has types and completion.
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			-- Show parameter-type hints only.
			hint = {
				enable = true,
				paramType = true,
				setType = false,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			diagnostics = {
				-- Globals this config defines or gets from plugins.
				globals = { "turalowski", "MiniIcons", "Snacks" },
				-- Noisy checks: partly filled setup tables and overriding module functions.
				disable = { "missing-fields", "duplicate-set-field" },
			},
		},
	},
}
