-- Claude Code integration: runs Claude in a terminal split and shares the editor's context with it.
require("claudecode").setup({
	terminal = {
		-- The snacks window colors itself NormalFloat when unfocused, which catppuccin
		-- paints solid; use Normal for both so it matches the transparent editor.
		snacks_win_opts = {
			wo = { winhighlight = "Normal:Normal,NormalNC:Normal" },
		},
	},
})
