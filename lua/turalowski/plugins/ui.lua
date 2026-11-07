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

-- One icon source: plugins that ask for nvim-web-devicons get mini.icons instead.
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("tiny-cmdline").setup({
	position = { x = "50%", y = "20%" },
})

local statusline = turalowski.statusline
local refresh_events = vim.list_extend(
	vim.deepcopy(require("lualine.config").get_config().options.refresh.events),
	{ "RecordingEnter", "RecordingLeave" }
)
require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = { events = refresh_events },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			statusline.root_name,
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			statusline.pretty_path,
		},
		lualine_x = { statusline.recording, "diagnostics", "diff" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
