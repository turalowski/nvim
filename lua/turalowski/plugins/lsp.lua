-- Mason installs language servers and formatters, and puts them on PATH.
require("mason").setup()

-- Install missing tools on start. Installed tools are never auto-updated.
require("mason-tool-installer").setup({
	ensure_installed = {
		-- Servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- Formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
	},
	auto_update = false,
	run_on_start = true,
})

-- Every server is told the client supports file renames, so oil renames can update imports.
vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
	},
})

-- nvim-lspconfig supplies the defaults for each server; these turn them on.
vim.lsp.enable({ "eslint", "oxlint", "lua_ls", "cssls", "vtsls", "tailwindcss", "rust_analyzer" })

-- Diagnostics: underlined, not updated while typing, worst first.
-- Inline text is "* message"; the source is shown only when several sources report.
local icons = turalowski.icons.diagnostics
local severity = vim.diagnostic.severity
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = { prefix = "*", source = "if_many" },
	signs = {
		text = {
			[severity.ERROR] = icons.Error,
			[severity.WARN] = icons.Warn,
			[severity.INFO] = icons.Info,
			[severity.HINT] = icons.Hint,
		},
	},
})
