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

-- Git (gitsigns).
local gs = require("gitsigns")

map("n", "<leader>gb", function()
	gs.blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	gs.blame()
end, { desc = "Blame buffer" })

-- Stage the whole buffer; when nothing is left to stage, unstage it instead.
map("n", "<leader>gs", function()
	if #(gs.get_hunks() or {}) > 0 then
		gs.stage_buffer()
	else
		gs.reset_buffer_index()
	end
end, { desc = "Stage / unstage buffer" })

map("n", "]h", function()
	gs.nav_hunk("next")
end, { desc = "Next hunk" })
map("n", "[h", function()
	gs.nav_hunk("prev")
end, { desc = "Previous hunk" })

-- stage_hunk unstages the hunk when it is already staged. In visual mode, only the selected lines.
map("n", "<leader>gh", function()
	gs.stage_hunk()
end, { desc = "Stage / unstage hunk" })
map("x", "<leader>gh", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Stage / unstage selected lines" })

-- Open the file as it was in the commit that last touched the cursor line, in a new tab,
-- with the cursor on that line.
map("n", "<leader>go", function()
	local file = vim.api.nvim_buf_get_name(0)
	local lnum = vim.fn.line(".")
	local dir = vim.fs.dirname(file)
	local blame = vim.system(
		{ "git", "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--", file },
		{ cwd = dir, text = true }
	)
		:wait()
	if blame.code ~= 0 then
		vim.notify("git blame failed:\n" .. blame.stderr, vim.log.levels.ERROR)
		return
	end
	local sha, orig_lnum = blame.stdout:match("^(%x+) (%d+)")
	local path = blame.stdout:match("\nfilename ([^\n]+)")
	if not sha or sha:match("^0+$") then
		vim.notify("This line is not committed yet.", vim.log.levels.WARN)
		return
	end
	local show = vim.system({ "git", "show", sha .. ":" .. path }, { cwd = vim.fs.root(file, ".git"), text = true })
		:wait()
	if show.code ~= 0 then
		vim.notify("git show failed:\n" .. show.stderr, vim.log.levels.ERROR)
		return
	end
	local ft = vim.bo.filetype
	vim.cmd.tabnew()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(show.stdout:gsub("\n$", ""), "\n"))
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = ft
	vim.api.nvim_buf_set_name(buf, sha:sub(1, 8) .. ":" .. path)
	vim.api.nvim_win_set_cursor(0, { tonumber(orig_lnum), 0 })
end, { desc = "Open file at the commit of this line" })

-- Diff view (codediff). Its buffers are named "CodeDiff ...", which marks a codediff tab.
local function in_codediff_tab()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)), ":t")
		if name:find("^CodeDiff") then
			return true
		end
	end
	return false
end

-- TODO: <leader>d (delete without copying, config/keymaps.lua) now waits up to timeoutlen
-- for v, h or H. Revisit later.
map("n", "<leader>dv", function()
	if in_codediff_tab() then
		vim.cmd.tabclose()
	else
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>dh", "<Cmd>CodeDiff history %<CR>", { desc = "File history" })
map("n", "<leader>dH", "<Cmd>CodeDiff history<CR>", { desc = "Repo history" })

-- lazygit in a float (snacks). Remembers this window so `e` in lazygit opens files here.
map("n", ";g", function()
	turalowski.lazygit.open()
end, { desc = "Open lazygit" })
