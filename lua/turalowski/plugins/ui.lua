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
	{ "RecordingEnter", "RecordingLeave", "LspAttach", "LspDetach" }
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
		lualine_x = {
			statusline.recording,
			{
				"diagnostics",
				symbols = {
					error = turalowski.icons.diagnostics.Error,
					warn = turalowski.icons.diagnostics.Warn,
					info = turalowski.icons.diagnostics.Info,
					hint = turalowski.icons.diagnostics.Hint,
				},
			},
			"diff",
			statusline.lsp_clients,
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- File name tag in the top-right corner of each window, so every split says which file it holds.
-- The active window's tag is pink with dark text. Colors come from the Catppuccin palette,
-- with its Mocha values as a fallback when another theme is active.
local ok, palettes = pcall(require, "catppuccin.palettes")
local palette = ok and palettes.get_palette() or { pink = "#f5c2e7", crust = "#11111b" }
require("incline").setup({
	hide = { cursorline = true },
	highlight = {
		groups = {
			InclineNormal = { guibg = palette.pink, guifg = palette.crust, gui = "bold" },
		},
	},
	render = function(props)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local icon, icon_hl = MiniIcons.get("file", name)
		-- On the pink tag the icon takes the dark text color; elsewhere it keeps its own color.
		local tag = { { icon .. " ", group = not props.focused and icon_hl or nil }, { name } }
		if vim.bo[props.buf].modified then
			tag[#tag + 1] = { " [+]" }
		end
		return tag
	end,
})

-- snacks.nvim: only the modules below are on for now. Later steps turn on more of it.
require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		-- Open in a vertical split, split, or new tab with ;v, ;h, ;o instead of <C-v>, <C-s>, <C-t>.
		win = {
			input = {
				keys = {
					["<c-v>"] = false,
					["<c-s>"] = false,
					["<c-t>"] = false,
					[";v"] = { "edit_vsplit", mode = { "i", "n" } },
					[";h"] = { "edit_split", mode = { "i", "n" } },
					[";o"] = { "tab", mode = { "i", "n" } },
				},
			},
			list = {
				keys = {
					["<c-v>"] = false,
					["<c-s>"] = false,
					["<c-t>"] = false,
					[";v"] = "edit_vsplit",
					[";h"] = "edit_split",
					[";o"] = "tab",
				},
			},
		},
	},
	lazygit = turalowski.lazygit.snacks,
})
