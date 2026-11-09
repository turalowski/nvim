# nvim/lua/turalowski

A Neovim 0.12 config built from a written spec, using Neovim's own features wherever they exist.

[`requirements.md`](requirements.md) describes the whole config step by step, and the git history follows it one commit per step.

## Requirements

- Neovim **0.12** or newer
- `git`, `curl`, `tar`
- `tree-sitter` CLI and a C compiler, to build Treesitter parsers
- Node.js and npm, for most language servers installed by Mason
- `ripgrep` and `fd`, for search and the file finder
- `lazygit` and `git-delta`, for the git UI and its diffs
- A [Nerd Font](https://www.nerdfonts.com/) (this config uses PlemolJP Console NF)
- Optional: the `claude` CLI, for the Claude Code integration
- Optional: tmux, with the [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) bindings in `~/.tmux.conf`, to move between Neovim and tmux panes

## Install

```sh
git clone https://github.com/turalowski/nvim.git ~/.config/nvim
nvim
```

On the first start, `vim.pack` installs the plugins, Treesitter builds its parsers, and Mason installs the language servers and formatters. This takes a few minutes.

## What's inside

| Area       | Plugins and features                                                                 |
| ---------- | ------------------------------------------------------------------------------------ |
| Look       | Catppuccin (transparent), lualine, custom tabline, incline window labels, mini.icons |
| Navigation | snacks.nvim picker, oil.nvim file explorer, harpoon                                  |
| Syntax     | nvim-treesitter (main branch), todo-comments, nvim-highlight-colors                  |
| LSP        | Mason, nvim-lspconfig, blink.cmp, mini.pairs                                         |
| Formatting | conform.nvim, format on save (oxfmt, prettierd, prettier, stylua, shfmt)             |
| Git        | gitsigns, codediff.nvim, lazygit through snacks.nvim                                 |
| Agents     | claudecode.nvim, copy file path with line                                            |
| Editing    | nvim-surround, Comment.nvim, nvim-ts-autotag                                         |
| Tools      | vim-tmux-navigator, which-key, vim-maximizer                                         |

## Layout

```
init.lua                   loads the modules below in order
lua/turalowski/
  utils/                   shared helpers (tabline, statusline, icons, lazygit)
  config/                  plain Neovim settings: options, keymaps, autocmds, commands
  plugins/                 one file per plugin group, keymaps.lua loaded last
after/lsp/                 per-server LSP settings
requirements.md            the spec
```

## Main keymaps

Leader is **Space**. The full list, with notes, is in [`requirements.md`](requirements.md).

| Keys                        | Action                                                        |
| --------------------------- | ------------------------------------------------------------- |
| `;f` / `;r`                 | Find files / live grep, hidden files included                 |
| `;b`                        | Open buffers                                                  |
| `;;`                        | Reopen the last picker                                        |
| `;d` / `;n` / `;h`          | Diagnostics / notifications / git hunks                       |
| `;e`                        | File explorer (oil) in a float                                |
| `gd` / `gr` / `gt` / `gI`   | Definition / references / type definition / source definition |
| `K` / `E`                   | Hover docs / diagnostic under the cursor                      |
| `<leader>ca` / `<leader>cr` | Code actions / rename                                         |
| `<leader>f`                 | Format now                                                    |
| `;g`                        | lazygit                                                       |
| `<leader>dv`                | Toggle the diff view                                          |
| `]h` / `[h`                 | Next / previous git hunk                                      |
| `<leader>li` / `<leader>fi` | Copy relative / absolute `path#L<line>`                       |
| `<leader>ac` / `<leader>as` | Toggle Claude / send the selection to Claude                  |
| `<leader>ab`                | Add the buffer to Claude                                      |
| `<leader>ha` / `<leader>hl` | Harpoon: add the file / list files                            |
| `<leader>h1` – `<leader>h4` | Harpoon: go to file 1–4                                       |
| `<C-h/j/k/l>`               | Move between windows and tmux panes                           |
| `<leader>sm`                | Maximize / restore the window                                 |

Commands: `:ToggleCompletion` (`!` for all buffers, `<leader>tc` for this buffer) and `:ToggleFormatter`.

Some of these shortcuts are still new to me, and I'm getting used to them. In future, I may change some of them to my own taste.
