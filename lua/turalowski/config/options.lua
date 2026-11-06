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



