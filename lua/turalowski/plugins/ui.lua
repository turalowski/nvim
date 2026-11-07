require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

-- Optional themes: comment out the catppuccin block above, then uncomment one below
-- (and its line in plugins/init.lua).

-- require("solarized-osaka").setup({
-- 	style = "vivid",
-- 	transparent = true,
-- })
-- vim.cmd.colorscheme("solarized-osaka")

-- require("tokyonight").setup({
-- 	style = "night",
-- 	transparent = true,
-- })
-- vim.cmd.colorscheme("tokyonight")

-- require("onedark").setup({
-- 	style = "dark",
-- 	transparent = true,
-- })
-- require("onedark").load()

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})
