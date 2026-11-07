local map = vim.keymap.set

-- Jump between occurrences of the word under the cursor (snacks words).
map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next occurrence of word" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous occurrence of word" })

-- Pickers (snacks picker).
map("n", ";f", function()
	Snacks.picker.files({ hidden = true })
end, { desc = "Find files, including hidden" })
map("n", ";r", function()
	Snacks.picker.grep({ hidden = true })
end, { desc = "Live grep, including hidden" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Reopen last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({ jump = { reuse_win = true } })
end, { desc = "List open buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "List diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Show notifications" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "List git hunks" })

-- File explorer (oil).
map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "Open oil in a float with preview" })

-- Keys inside oil buffers only.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("turalowski_oil_keymaps", { clear = true }),
	pattern = "oil",
	desc = "Oil buffer keymaps",
	callback = function(ev)
		local actions = require("oil.actions")
		map("n", "h", actions.parent.callback, { buffer = ev.buf, desc = "Parent directory" })
		map("n", "q", actions.close.callback, { buffer = ev.buf, desc = "Close oil" })
	end,
})

-- TypeScript: ask vtsls for the source definition (the .ts file, not the .d.ts types).
-- Other languages: list implementations.
local function source_definition_or_implementation()
	local client = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not client then
		Snacks.picker.lsp_implementations()
		return
	end
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			vim.notify("No source definition found.", vim.log.levels.WARN)
			return
		end
		local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
		if #items == 1 then
			vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
		else
			vim.fn.setqflist({}, " ", { title = "Source definitions", items = items })
			Snacks.picker.qflist()
		end
	end)
end

-- LSP keys (5.7), only in buffers with a language server, so other buffers keep the built-in
-- gd, gt and gr. Lists and jumps go through the snacks picker.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("turalowski_lsp_keymaps", { clear = true }),
	desc = "LSP keymaps",
	callback = function(ev)
		local function bmap(mode, lhs, rhs, desc, opts)
			map(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, opts or {}))
		end
		bmap("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, "Go to definition")
		bmap("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, "Go to declaration")
		bmap("n", "gt", function()
			Snacks.picker.lsp_type_definitions()
		end, "Go to type definition")
		-- nowait: fire at once instead of waiting for the built-in grn/gra/grr/gri/grt/grx keys.
		bmap("n", "gr", function()
			Snacks.picker.lsp_references()
		end, "List references", { nowait = true })
		bmap("n", "gI", source_definition_or_implementation, "Go to source definition / implementation")
		bmap("n", ";c", function()
			Snacks.picker.lsp_incoming_calls()
		end, "List incoming calls")
		bmap("n", "gK", vim.lsp.buf.signature_help, "Signature help")
		bmap("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
		bmap({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
		bmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		bmap("n", "<leader>cR", function()
			Snacks.rename.rename_file()
		end, "Rename file, update imports")
		bmap("n", "<leader>cl", function()
			Snacks.picker.lsp_config()
		end, "LSP info")
	end,
})

-- Format the buffer now (conform, falling back to the LSP).
map({ "n", "x" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format now" })
