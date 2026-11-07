-- lazygit in a snacks float, wired to open files back in this Neovim.
-- TODO: In future, ~/.config/lazygit/config.yml will be added and these lazygit settings
-- can move there. On macOS lazygit only reads ~/.config/lazygit when XDG_CONFIG_HOME is set;
-- otherwise it uses ~/Library/Application Support/lazygit.
local M = {}

-- Window that was current when lazygit opened; `e` sends files back to it.
local origin_win

-- `e` on a file: quit lazygit, focus the origin window, then open the file there.
-- Outside Neovim ($NVIM unset) it just runs `nvim <file>`.
local EDIT = table.concat({
	'[ -z "$NVIM" ] && nvim -- {{filename}} || {',
	'nvim --server "$NVIM" --remote-send "q" &&',
	'nvim --server "$NVIM" --remote-send "<Cmd>lua turalowski.lazygit.focus_origin()<CR>" &&',
	'nvim --server "$NVIM" --remote {{filename}}; }',
}, " ")

-- Settings snacks writes into its generated lazygit config, next to the synced theme.
M.snacks = {
	config = {
		os = { edit = EDIT, editInTerminal = false },
		git = {
			autoFetch = false,
			paging = { colorArg = "always", pager = 'delta --dark --paging=never --syntax-theme="Solarized (dark)"' },
		},
		gui = { mouseEvents = false },
	},
	theme = {
		activeBorderColor = { fg = "WarningMsg", bold = true },
	},
}

-- customCommands is a list of tables, which the snacks YAML writer cannot produce,
-- so it goes into a small file of its own.
local EXTRA = {
	"customCommands:",
	'  - key: "C"',
	'    context: "files"',
	'    command: "git cz"',
	'    description: "Commit with commitizen"',
	"    subprocess: true",
}

-- Tell lazygit to load: its own config.yml (if any), then the extra file. snacks adds its
-- theme file after these.
local function set_config_files()
	if vim.env.LG_CONFIG_FILE and vim.env.LG_CONFIG_FILE ~= "" then
		return
	end
	local extra = vim.fn.stdpath("cache") .. "/lazygit-extra.yml"
	vim.fn.writefile(EXTRA, extra)
	local files = {}
	local dir = vim.trim(vim.fn.system({ "lazygit", "-cd" }))
	if vim.v.shell_error == 0 and vim.uv.fs_stat(dir .. "/config.yml") then
		files[#files + 1] = dir .. "/config.yml"
	end
	files[#files + 1] = extra
	vim.env.LG_CONFIG_FILE = table.concat(files, ",")
end

function M.open()
	origin_win = vim.api.nvim_get_current_win()
	set_config_files()
	Snacks.lazygit()
end

function M.focus_origin()
	if origin_win and vim.api.nvim_win_is_valid(origin_win) then
		vim.api.nvim_set_current_win(origin_win)
	end
end

return M
