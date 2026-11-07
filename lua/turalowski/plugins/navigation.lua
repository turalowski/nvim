-- oil.nvim: the directory is a buffer. Edit names as text, then :w to apply.
require("oil").setup({
	default_file_explorer = true,
	columns = { "icon", "permissions", "size", "mtime" },
	view_options = { show_hidden = true },
	-- Renames ask the LSP to update imports, and the changed files are saved.
	lsp_file_methods = { enabled = true, autosave_changes = true },
	float = { max_width = 200, border = "rounded" },
})
