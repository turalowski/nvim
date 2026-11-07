-- Neovim does not detect .mdx files on its own.
vim.filetype.add({ extension = { mdx = "mdx" } })

-- oxfmt only for projects that use it: an oxfmt config file, or a Vite+ config with a fmt section.
-- Everything else falls through to prettierd / prettier.
local function has_oxfmt_config(dirname)
	if vim.fs.root(dirname, { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }) then
		return true
	end
	local vite = vim.fs.find({ "vite.config.ts", "vite.config.js" }, { path = dirname, upward = true })[1]
	if not vite then
		return false
	end
	local ok, lines = pcall(vim.fn.readfile, vite)
	return ok and table.concat(lines, "\n"):find("%f[%w]fmt%s*:") ~= nil
end

local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

require("conform").setup({
	formatters_by_ft = {
		javascript = web,
		typescript = web,
		javascriptreact = web,
		typescriptreact = web,
		json = web,
		css = web,
		scss = web,
		less = web,
		html = web,
		markdown = web,
		mdx = web,
		yaml = web,
		lua = { "stylua" },
		sh = { "shfmt" },
	},
	formatters = {
		oxfmt = {
			condition = function(_, ctx)
				return has_oxfmt_config(ctx.dirname)
			end,
		},
	},
	-- Format on save, unless :ToggleFormatter turned it off for this buffer.
	format_on_save = function(bufnr)
		if vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})
