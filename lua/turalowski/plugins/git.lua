-- Git signs in the gutter, with defaults.
require("gitsigns").setup()

-- Side-by-side diffs and history (:CodeDiff), handy for reviewing large changes.
require("codediff").setup({
	explorer = {
		view_mode = "tree",
		width = 50,
		-- Moving the cursor in the explorer opens the file under it.
		auto_open_on_cursor = true,
		-- +/- line counts next to each file.
		line_stats = { enabled = true },
	},
	diff = {
		-- Compact mode (gc): only the changes, no context lines, folds kept in sync across panes.
		compact_context_lines = 0,
		compact_sync_folds = true,
	},
})
