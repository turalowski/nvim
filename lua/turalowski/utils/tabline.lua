local M = {}

-- Powerline triangles. Left edge fills the bottom right, right edge the bottom left,
-- so each tab is a trapezoid that is wider at the bottom.
local SEP_LEFT = "\u{e0ba}"
local SEP_RIGHT = "\u{e0b8}"
local PAD = "   "
local MAX_NAME = 20
local CUT_NAME = 17

local function get_hl(name, key)
	return vim.api.nvim_get_hl(0, { name = name, link = false })[key]
end

-- Build the tab colors from the current colorscheme, so they follow theme changes.
function M.set_highlights()
	local active_fg = get_hl("TabLineSel", "fg") or get_hl("Normal", "fg")
	local active_bg = get_hl("Visual", "bg") or get_hl("TabLineSel", "bg")
	local inactive_fg = get_hl("TabLine", "fg") or get_hl("Comment", "fg")
	local inactive_bg = get_hl("TabLine", "bg") or get_hl("CursorLine", "bg")

	vim.api.nvim_set_hl(0, "TuralTabActive", { fg = active_fg, bg = active_bg, bold = true })
	vim.api.nvim_set_hl(0, "TuralTabActiveSep", { fg = active_bg })
	vim.api.nvim_set_hl(0, "TuralTabInactive", { fg = inactive_fg, bg = inactive_bg })
	vim.api.nvim_set_hl(0, "TuralTabInactiveSep", { fg = inactive_bg })
	-- Empty area after the last tab stays transparent.
	vim.api.nvim_set_hl(0, "TabLineFill", {})
end

-- Label for one tab: "[+] " when unsaved, then icon and file name of its active window.
local function label(tabnr)
	local win = vim.api.nvim_tabpage_get_win(vim.api.nvim_list_tabpages()[tabnr])
	local buf = vim.api.nvim_win_get_buf(win)
	local modified = vim.bo[buf].modified and "[+] " or ""

	if vim.bo[buf].buftype == "terminal" then
		return modified .. "[Terminal]"
	end
	-- Oil tabs show their directory as "~/foo", no icon. Long paths keep their last 17 characters.
	if vim.bo[buf].filetype == "oil" then
		local dir = vim.api.nvim_buf_get_name(buf):gsub("^oil://", ""):gsub("/$", "")
		dir = vim.fn.fnamemodify(dir == "" and "/" or dir, ":~")
		local len = vim.fn.strchars(dir)
		if len > MAX_NAME then
			dir = "..." .. vim.fn.strcharpart(dir, len - CUT_NAME)
		end
		return modified .. dir
	end
	local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
	if name == "" then
		return modified .. "[No Name]"
	end

	-- Pick the icon from the full name, before a long name loses its extension.
	local icon = _G.MiniIcons and (MiniIcons.get("file", name) .. " ") or ""
	if vim.fn.strchars(name) > MAX_NAME then
		name = vim.fn.strcharpart(name, 0, CUT_NAME) .. "..."
	end
	return modified .. icon .. name
end

-- Called by 'tabline' on every redraw.
function M.render()
	local parts = {}
	local current = vim.fn.tabpagenr()
	for tabnr = 1, vim.fn.tabpagenr("$") do
		local kind = tabnr == current and "Active" or "Inactive"
		local text = label(tabnr):gsub("%%", "%%%%")
		parts[#parts + 1] = table.concat({
			"%#TuralTab" .. kind .. "Sep#" .. SEP_LEFT,
			"%#TuralTab" .. kind .. "#" .. PAD .. text .. PAD,
			"%#TuralTab" .. kind .. "Sep#" .. SEP_RIGHT,
		})
	end
	return table.concat(parts) .. "%#TabLineFill#"
end

M.set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("turalowski_tabline", { clear = true }),
	desc = "Rebuild tabline colors for the new colorscheme",
	callback = M.set_highlights,
})

return M
