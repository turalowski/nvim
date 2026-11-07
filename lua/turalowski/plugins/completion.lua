require("blink.cmp").setup({
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
