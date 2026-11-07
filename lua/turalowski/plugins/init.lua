vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	-- Optional themes: uncomment one here and its block in ui.lua to switch.
	-- "https://github.com/craftzdog/solarized-osaka.nvim",
	-- "https://github.com/folke/tokyonight.nvim",
	-- "https://github.com/navarasu/onedark.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/rachartier/tiny-cmdline.nvim",
})

require("turalowski.plugins.ui")
require("turalowski.plugins.keymaps")
