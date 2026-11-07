local M = {}

local ROOT_MARKERS = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

-- Project root of the current buffer: the nearest folder upward holding one of the markers.
-- Falls back to the current working directory.
function M.root()
	return vim.fs.root(0, ROOT_MARKERS) or vim.fn.getcwd()
end

-- Name of the project root, only when it differs from the current working directory.
function M.root_name()
	local root = M.root()
	if vim.fs.normalize(root) == vim.fs.normalize(vim.fn.getcwd()) then
		return ""
	end
	return vim.fs.basename(root)
end

-- File path relative to the project root, shortened to its last 3 parts.
function M.pretty_path()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "[No Name]"
	end
	local path = vim.fs.relpath(M.root(), name) or vim.fn.fnamemodify(name, ":~")
	local parts = vim.split(path, "/", { plain = true })
	if #parts > 3 then
		path = "…/" .. table.concat(parts, "/", #parts - 2)
	end
	return path
end

-- "recording @q" while a macro is being recorded, empty otherwise.
function M.recording()
	local reg = vim.fn.reg_recording()
	return reg == "" and "" or ("recording @" .. reg)
end

return M
