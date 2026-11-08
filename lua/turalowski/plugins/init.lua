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
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/esmuellert/codediff.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/coder/claudecode.nvim",
	"https://github.com/christoomey/vim-tmux-navigator",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/szw/vim-maximizer",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

require("turalowski.plugins.ui")
require("turalowski.plugins.navigation")
require("turalowski.plugins.syntax")
require("turalowski.plugins.completion")
require("turalowski.plugins.lsp")
require("turalowski.plugins.formatting")
require("turalowski.plugins.git")
require("turalowski.plugins.ai")
require("turalowski.plugins.tools")
require("turalowski.plugins.editing")
require("turalowski.plugins.keymaps")
