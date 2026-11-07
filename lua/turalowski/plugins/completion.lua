require("blink.cmp").setup({
	-- Off when :ToggleCompletion turned it off for this buffer, or :ToggleCompletion! for all.
	enabled = function()
		return vim.g.completion ~= false and vim.b.completion ~= false
	end,
	-- Enter accepts the selected item.
	keymap = { preset = "enter" },
	completion = {
		accept = { auto_brackets = { enabled = true } },
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		-- Copilot shows inline suggestions; a second ghost text would clash.
		ghost_text = { enabled = false },
		menu = {
			draw = {
				-- Color item labels with Treesitter.
				treesitter = { "lsp" },
				-- Kind icons and their colors come from mini.icons.
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = MiniIcons.get("lsp", ctx.kind)
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							local _, hl = MiniIcons.get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
	},
	cmdline = {
		completion = {
			-- Open the menu by itself only for ":" commands, with nothing preselected.
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
			list = { selection = { preselect = false } },
			ghost_text = { enabled = false },
		},
	},
})

-- Auto-close brackets and quotes with mini.pairs defaults, also in the command line.
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})
