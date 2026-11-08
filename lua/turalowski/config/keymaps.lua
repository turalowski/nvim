local map = vim.keymap.set

-- Delete a character without copying it.
map("n", "x", '"_x', { desc = "Delete char without copying" })

map("n", "<leader>nh", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Delete, change and paste through the black hole register, so the yanked text stays.
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
map("x", "<leader>p", '"_dP', { desc = "Paste over selection, keep yank" })

map("n", "dw", '"_db', { desc = "Delete word backwards without copying" })

map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })

map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

map("n", "<leader>to", "<Cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<Cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<Tab>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<S-Tab>", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<Cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

map("n", "<leader>tc", "<Cmd>ToggleCompletion<CR>", { desc = "Toggle completion for this buffer" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>ss", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<Cmd>close<CR>", { desc = "Close current split" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Scroll and search, then center the cursor line (zv also opens a fold around a match).
map("n", "<C-d>", "<C-d>zz", { desc = "Page down, keep cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up, keep cursor centered" })
map("n", "n", "nzzzv", { desc = "Next match, keep cursor centered" })
map("n", "N", "Nzzzv", { desc = "Previous match, keep cursor centered" })

-- Tab and <C-i> send the same key in most terminals, and Tab now switches tabs,
-- so jumping forward in the jump list moves to <C-m>.
map("n", "<C-m>", "<C-i>", { desc = "Jump forward in jump list" })

-- Open a new line, then clear it with cc so a comment leader is not carried over.
map("n", "<leader>o", 'o<Esc>"_cc', { desc = "Open line below without comment" })
map("n", "<leader>O", 'O<Esc>"_cc', { desc = "Open line above without comment" })

-- Ask for a message, then stage everything, make a signed commit and push.
-- Each git step stops the chain and shows git's error if it fails.
local function git_workflow()
	local message = vim.fn.input("Enter commit message: ")
	if message == "" then
		vim.notify("Commit message is empty. Aborting.", vim.log.levels.WARN)
		return
	end
	local steps = {
		{ "git", "add", "." },
		{ "git", "commit", "-S", "-m", message },
		{ "git", "push" },
	}
	for _, cmd in ipairs(steps) do
		local result = vim.system(cmd, { text = true }):wait()
		if result.code ~= 0 then
			vim.notify(table.concat(cmd, " ", 1, 2) .. " failed:\n" .. result.stderr, vim.log.levels.ERROR)
			return
		end
	end
	vim.notify("Committed and pushed.")
end

map("n", "<leader>up", git_workflow, { desc = "Fast commit/push" })

-- Copy "path:L<line>" of the cursor position to the system clipboard.
-- Copy "path#L<line>" to the system clipboard, for pointing an agent at the exact line (7.1).
local function copy_path(modifier)
	local text = vim.fn.expand("%" .. modifier) .. "#L" .. vim.fn.line(".")
	vim.fn.setreg("+", text)
	vim.notify("Copied " .. text)
end
map("n", "<leader>li", function()
	copy_path(":.")
end, { desc = "Copy relative path and line" })
map("n", "<leader>fi", function()
	copy_path(":p")
end, { desc = "Copy absolute path and line" })

-- Delete every listed buffer that no window shows, skipping ones with unsaved changes.
local function close_hidden_buffers()
	local closed = 0
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if #buf.windows == 0 and buf.changed == 0 then
			vim.cmd.bdelete(buf.bufnr)
			closed = closed + 1
		end
	end
	vim.notify(("Closed %d hidden buffer(s)."):format(closed))
end

map("n", "<leader>bd", close_hidden_buffers, { desc = "Close hidden buffers" })

map("n", "<leader>bx", "<Cmd>bdelete<CR>", { desc = "Close current buffer" })
map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- checktime looks for files changed outside Neovim; with 'autoread' on, unmodified buffers reload.
map("n", "<leader>R", "<Cmd>checktime<CR>", { desc = "Reload files changed on disk" })

-- Diagnostic float (5.7). Works in any buffer with diagnostics.
-- The other LSP keys use plugins and live in plugins/keymaps.lua.
map("n", "E", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
