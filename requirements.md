# Set Up Neovim

## Workflow

- Read the spec and implement only the step I name. Add nothing beyond it.
- Check your work lightly:
    - Neovim starts without errors: `nvim --headless +qa`
    - New keymaps exist: `verbose map <key>`
Don't build test projects or drive the UI. I check the behaviour myself after `ZR`.

## Prerequisites

## 0.1 Neovim

- Neovim 0.12 or newer.
- The config relies on built-ins that landed in 0.12:
    - `vim.pack`, `vim.lsp.enable`, and the ui2 message UI.

## 0.2 CLI Tools

- `git`: `vim.pack` clones plugins with it.
- `tree-sitter` CLI and a C compiler: `nvim-treesitter`'s main branch builds parsers locally.
- `curl` and `tar`: parser and blink.cmp binary downloads.
- Node.js + npm: `Mason` installs most language servers through npm.
- `ripgrep` and `fd`: back the text search and the file finder.
- `lazygit` and `git-delta`: the git UI and its diff renderer.
 
 ## 0.3 Font

 - A Nerd Font, PlemolJP, Console NF.
 - Icons appear in the tabline, statusline, completion menu, and file explorer so a plain font shows boxes.

 ## 0.4 Git

 - The config folder is a git repository.
 - `.gitignore` lists `nvim-pack-lock.json`
 - 
