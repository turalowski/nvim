-- vim-tmux-navigator: <C-h/j/k/l> cross between Neovim splits and tmux panes.
-- Its own mappings are off; plugins/keymaps.lua binds the keys.
vim.g.tmux_navigator_no_mappings = 1

-- which-key: shows the keys that can follow after a pause of timeoutlen (500ms, options.lua).
require("which-key").setup()

-- nvim-ts-autotag: closes and renames HTML/JSX tags as you type.
require("nvim-ts-autotag").setup()
