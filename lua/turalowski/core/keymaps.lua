vim.g.mapleader = " "

local keymap = vim.keymap -- for consiseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Delete character will not copy character to register
keymap.set("n", "x", '"_x', { desc = "Delete character will not copy character to register" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Buffer shortcuts
keymap.set("n", "<leader>bx", ":bdelete<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bp", ":bprev<CR>", { desc = "Go to previous buffer" })

-- Modify screen navigations to keep the cursor in the middle
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor in the middle on page down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "keep cursor in the middle on page up" })
keymap.set("n", "n", "nzzzv", { desc = "Keep cursor in the middle on highlight of next search item" })
keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor in the middle on highlight previous search item" })

function GitWorkflow()
	local commit_message = vim.fn.input("Enter commit message: ")
	if commit_message == "" then
		print("Commit message is empty. Aborting.")
		return
	end
	vim.fn.system("git add .")
	vim.fn.system("git commit -S -m '" .. commit_message .. "'")
	vim.fn.system("git push")
end

keymap.set("n", "<leader>up", [[:lua GitWorkflow()<CR>]], { noremap = true, silent = true, desc = "Fast commit/push" })
