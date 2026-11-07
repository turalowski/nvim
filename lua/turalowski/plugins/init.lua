-- Keep Treesitter parsers in sync with the plugin: update them whenever vim.pack installs or
-- updates nvim-treesitter. Defined before vim.pack.add so it also runs on the first install.
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("turalowski_pack", { clear = true }),
	desc = "Update Treesitter parsers after nvim-treesitter changes",
	callback = function(ev)
		local data = ev.data
		if data.spec.name == "nvim-treesitter" and data.kind ~= "delete" then
			if not data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	-- Optional themes: uncomment one here and its block in ui.lua to switch.
	-- "https://github.com/craftzdog/solarized-osaka.nvim",
	-- "https://github.com/folke/tokyonight.nvim",
	-- "https://github.com/navarasu/onedark.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/b0o/incline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
})

require("turalowski.plugins.ui")
require("turalowski.plugins.navigation")
require("turalowski.plugins.syntax")
require("turalowski.plugins.completion")
require("turalowski.plugins.lsp")
require("turalowski.plugins.keymaps")
