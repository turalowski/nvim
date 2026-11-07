vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
-- >>, <<, = moves text by 2 spaces.
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
-- when new line starts, neovim guesses the indentation from basic syntax.
vim.opt.smartindent = true

-- my-basic-variable becomes one word.
vim.opt.iskeyword:append("-")


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 0
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.winborder = "rounded"
-- Popup boxes height and width
vim.opt.pumheight = 10
vim.opt.pumblend = 10
-- When you type a closing, the cursor jumps briefly to the matching opening bracket, then comes back.
vim.opt.showmatch = true
-- How long the jump lasts.
vim.opt.matchtime = 2
vim.opt.title = true
-- TODO: In future can be removed. I am not sure if I need this config.
vim.opt.fillchars:append({ diff = "╱" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Adding ** means “this folder and every folder inside it, all the way down.
vim.opt.path:append("**")
vim.opt.wildmode = { "longest:full", "full" }
-- Files that match these patterns are skipped by file completion and :find.
vim.opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
vim.opt.swapfile = false
vim.opt.writebackup = false
-- Saves your undo history to disk. Normally undo history is lost when you close a file. With this on, you can close a file, open it tomorrow, and still press u to undo yesterday’s changes.
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

require("vim._core.ui2").enable({
	msg = {
		target = "msg",
		targets = {
			typed_cmd = "cmd",
			search_count = "cmd",
			search_cmd = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			-- Disabled: Neovim tags the Ctrl+C "Type :qa" hint as list_cmd, so it opened the pager
			-- and took the cursor. Typed listings like :ls still go to the command line.
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
		},
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
