# Set Up Neovim

## Workflow

- Read the spec and implement only the step I name. Add nothing beyond it.
- Check your work lightly:
  - Neovim starts without errors: `nvim --headless +qa`
  - New keymaps exist: `verbose map <key>`
    Don't build test projects or drive the UI. I check the behaviour myself after `ZR`.

## Prerequisites

### 0.1 Neovim

- Neovim 0.12 or newer.
- The config relies on built-ins that landed in 0.12:
  - `vim.pack`, `vim.lsp.enable`, and the ui2 message UI.

### 0.2 CLI Tools

- `git`: `vim.pack` clones plugins with it.
- `tree-sitter` CLI and a C compiler: `nvim-treesitter`'s main branch builds parsers locally.
- `curl` and `tar`: parser and blink.cmp binary downloads.
- Node.js + npm: `Mason` installs most language servers through npm.
- `ripgrep` and `fd`: back the text search and the file finder.
- `lazygit` and `git-delta`: the git UI and its diff renderer.

### 0.3 Font

- A Nerd Font, PlemolJP, Console NF.
- Icons appear in the tabline, statusline, completion menu, and file explorer so a plain font shows boxes.

### 0.4 Git

- The config folder is a git repository.
- `.gitignore` lists `nvim-pack-lock.json`

## 1 Foundation

### 1.1 Layout

- `~/.config/nvim`: the config root folder.
- `init.lua`: enables `vim.loader` for faster startup, then requires these files directly, in order:
  1. `.turalowski.utils` assigned to the global `turalowski`
  2. `turalowski.config.options`, `.keymaps` `.autocmds`, `.commands`, `.workarounds`
  3. `turalowski.plugins`
     - `lua/turalowski/`: my config lives here
     - `utils`: shared helpers
     - `init.lua`: returns a table or helper modules, empty for now. Later steps add modules like `utils/editor.lua`, exposed as `editor`
     - `config/`: plain Neovim settings, on file per name above.
     - `plugins/`:
       - `init.lua`: will install every plugin in one `vim.pack.add` call, then require each group file.
       - Each plugin group gets its own file next to it later (e.g., `ui.lua`), which configures its plugins with `require/(<plugin>).setup({...})`
       - `keymaps.lua`: every keymap that uses a plugin, required last so all plugins are setup up first. Group files hold no keymaps.
     - Lua files are indended with tabs, formatted by stylua with its defaults.

### 1.2 Leader and basics

- Leader and local leader are **Space**.
- Mouse is **off**, Keyboard-only.
- Clipboard is `unnamedplus`, so yank and paste go through the system clipboard.
- Indent is **2 spaces**: `tabstop`, `shiftwidth`, and `softtabstop` are all **2**, with `expandtab` and `smartindent` **on**.
- `-` counts as part of a word, so `foo-bar` is one word.
  - Fits CSS classes and kebab-case names.

### 1.3 Look of the buffer

- **Hybrid** line numbers: `number` + `relativenumber` **on**, so the cursor line shows its real number.
- `cursorline` **on**. No wrap, `scrolloff` **10**, `sidescrolloff` **0**.
- `signcolumn` **always on**.
  - Text doesn't jump when git or diagnostics marks appear.
  - `cmdheight` **0** and one global statusline (`laststatus` **3**).
    - Maximizes vertical space
  - **Rounded** borders on every float (`winborder`)
  - Popup menu: at most **10** rows, slightly see-through, (`pumheight` **10**, `pumblend` **10**)
  - Matching brackets flash briefly. (`showmatch` **on**, `matchtime** **2**).
  - title **on** so the terminal tab shows the file name.
  - Diagonal `/` fill in empty diff areas

### 1.4 Search, files, undo

- `ignorecase` + `smartcase` **on**: case-insensitive until a capital letter is typed.
- `path` adds `**`, so `:find` searches subfolders.
- `:` completion: `wildmode` is `ongest:full`, `full`. `wildignore` skips `*/node_modules/*`, `*.o`, `*.obj`, `*.pyc`, `*.class`, `*.jar`.
- `swapfile` and `writebackup` **off**. Persistent undo (`undofile` **on**) lives in `~/.cache/nvim/undodir`.
  - Undo survives closing the file. Swap files only get in the way.
- Snappier timing: `updatetime` **300**, `timeoutlen` **500**, `ttimeoutlen` **0**.
  - Faster CursorHold events, and key sequences resolve without lag.

### 1.5 Splits and folds

- New splits open **below** and to the **right**.
- Folds come from **Treesitter**, with `foldlevel` **99**.
  - Everything starts unfolded, and folds can still be closed by syntax.

### 1.6 Messages

- Neovim 0.12's experimental ui2 handles messages. Turn it on at the end of `config/options.lua`
  - Short messages: corner popup up to **30%** of the screen tall, gone after **5 seconds**
  - Long output (errors, listing like `:ls`, `:verbose`, shell commands and their output, progress): a scrollable pager up to **half** the screen.
  - Search count, search pattern, completion, `:` completion list, and confirm prompts stay in the command line.
  - Output of a command I type goes to the command line too, whatever its kind. It expands over the bottom of the screen until the next day, and "Enter" moves it into the pager.
  - `tiny-cmdline.nvim` shows the `:` command line as a floating box centered left to right, **20%** from the top. It's set up in `plugins/ui.lua`
    - With `cmdheight` 0 the command line needs somewhere to appear, and near the top is where the eyes already are.

### 1.7 Autocmds

- Yanked text flashes briefly.
- Only the active window shows the cursorline.

### 1.8 Core Keymaps

| Keys                                                                                       | Action                                                                                                           | Notes                                               |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| 'x'                                                                                        | Deletes without copying                                                                                          | -                                                   |
| `<leader>nh`                                                                               | Clear search highlights                                                                                          | -                                                   |
| `<leader>d`, `<leader>c`, `<leader>p`                                                      | Delete, change, and paste without touching the yank                                                              | The yanked text stays safe while editing around it. |
| `dw`                                                                                       | Deletes the word backwards without copying                                                                       | -                                                   |
| `+` / `-`                                                                                  | Increment and decrement numbers                                                                                  | -                                                   |
| `<C-a>`                                                                                    | Selects all                                                                                                      | -                                                   |
| `<leader>to`, `<leader>tx`, `<leader>tn` / `Tab`, `<leader>tp` / `Shift-Tab`, `<leader>tf` | Open new tab, Close current tab, Go next tab, To to previous tab, Open current buffer in new tab                 | -                                                   |
| `<leader>sv`, `<leader>ss`, `<leader>se`, `<leader>sx`                                     | Split vertical, Split horizontal, Make splits equal size, Close current split                                    | -                                                   |
| `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`                                                         | Move between windows                                                                                             | -                                                   |
| `<C-d>`                                                                                    | Keep cursor in the middle on page down                                                                           | -                                                   |
| `<C-u>`                                                                                    | Keep cursor in the middle on page up                                                                             | -                                                   |
| `n`                                                                                        | Keep cursor in the middle on highlight of next search item                                                       | -                                                   |
| `N`                                                                                        | Keep cursor in the middle on highlight previous search item                                                      | -                                                   |
| `<C-m>`                                                                                    | Jumps forward in the jump list                                                                                   | -                                                   |
| `<leader>o` / `<leader>O`                                                                  | Open a line below or above without continuing a comment                                                          | -                                                   |
| `<leader>up`                                                                               | Fast commit and push: asks for a message, then runs `git add .`, a signed `git commit -S`, and `git push`        | Aborts when the message is empty.                   |
| `<leader>li`                                                                               | Copy the file path and line number to the system clipboard, as `path:Lline`                                      | -                                                   |
| `<leader>bx`, `<leader>bn`, `<leader>bp`, `<leader>bd`                                     | Close current buffer, Go to next buffer, Go to previous buffer, Closes every hidden buffer, except unsaved ones. | -                                                   |
| `<leader>R`                                                                                | Reload files changed on disk                                                                                     | -                                                   |

### 2.0 Look & feel

- `catpuccin` style **transparent** background.
  - `solarized-osaka`, `vivid` style **transparent** background, `tokyo-night`, `onedark` should be optional, commented.

### 2.2 Icons

- `mini.icons`, also mocking `nvim-web-devicons`.
  - One icon source for every plugin.

### 2.3 Tabline

- Custom tabline in `utils/tabline.lua`, shown only when there are **2** or more tabs.
- Each tab shows t he active window's file name with its icon, padded with **3** spaces, between slanted separators. Both edges slant outward going down, so each tab is a trapezoid, wider at the bottom, like:
  - tab-style
  - Differ active and inactive tab with trext and background colors.
  - The icon takes the tab's text color.
  - The separators take the tab's color on a transparent background, and so does the empty area after the last tab.
- Names longer than **20** characters are cut to **17** oplus `...`
- Unsaved tabs shows `[+]` before the icon.
- Terminal show `[Terminal]` and empty buffers `[No Name]`, with no icon.

### 2.4 Statusline

- lualine, one global bar, theme `auto`.
  - a: mode
  - b: git branch
  - c: project root name (only when it differs from cwd), filetype icon, pretty file path
  - x: macro recording register, diagnostics, git diff counts
  - y: progress
  - z: line:column
- The project root is found be searching upward for `.git`, `lua`, `package.json`, `Makefile`, `Cargo.toml`, `go.mod`, or `pyproject.toml`.
  - Refreshes on cursor move and macro start/stop.
- The recording indicator replaces the hidden command line.

### 2.5 Window labels

- incline.nvim shows a filename tag with an icon in the top-right corner of each window, plus `[+]` when unsaved.
  - With a single global statusline, each split still needs to say which file it holds.
- The tag hides when the cursor reaches its line.
- The active window's tag is **pink** with dark text.
  - The icon takes the dark text color, so it stays readable on pink.

### 2.6 Snacks

- `snacks.nvim` provides notifier, indent guides, statuscolumn, and word highlighting.
- I'll turn on more of it in later steps, like this picker and the lazygit integration.
- Words: the word under the cursor is highlighted everywhere. `]]` / `[[` jump between occurrences.
- Smooth scroll is _off_*.
  - Scrolling should feel instant.

## 3. Navigating

### 3.1 Picker

- `snacks.nvim` picker.

| Keys | Action                             | Comment                                                                |
| ---- | ---------------------------------- | ---------------------------------------------------------------------- |
| `:f` | Finds files, including hidden ones | Dotfiles like `.github/` and `.env.example` are part ofd real projects | -   |
| `;r` | Live-greps, including hidden files | -                                                                      |
| `;;` | Reopens the last picker            | -                                                                      |
| `\\` | Lists open buffers                 | Jumps to a window that already shows the buffer.                       |
| `;e` | Lists diagnostics                  | -                                                                      |
| `;n` | Shows notifications                | -                                                                      |
| `;h` | Lists git hunks                    | -                                                                      |

### 3.2 File explorer

- oil.nvim replaces netrw and shows hidden files.
  - The directory is a buffer, so renaming, moving, and deleting files in plain text edition followed by `;w`
- Columns: icon, permissions, size, modified time.
- Renaming a file asks the LSP to update imports and saves those edits automatically.
- In the tabline (2.3), an oil tab shows its directory (`~/foo`) with no icon. Paths longer that **20** characters are cut from the left to `...` plus the last **17**.

| Keys | Action                                            | Notes                                               |
| ---- | ------------------------------------------------- | --------------------------------------------------- |
| `sf` | Opens oil as a centered float with a live preview | At most **200** columns wide, with rounded corners. |
| `h`  | Goes to the parent directory                      | -                                                   |
| `q`  | Closes oil                                        | -                                                   |

## Syntax

### 4.1 Treesitter

- `nvim-treesitter`, main branch.
- Ensures parsers: astro, bash, c, cmake, cpp, css, diff, fish, gitignore, go graghql, html, http, java, javascript, jsdoc, json, lua, luadoc, luap, markdown, markdown_inline, php, printf, python, query, regex, rust, scss, sql, svelte, toml, tsx, typescript, vim, vimdoc, xml, yaml, docker, composer.
- A FileType autocmd starts highlighting and Treesitter indent whenever a parser exists.
- `TSUpdate` runs on the `PackChanged` event.
- Parsers stay in sync with the plugin version.

### 4.2 Small highlights

- `todo-comments.nvim` highlights `TODO`, `FIXME`, and the like, with defaults.
- `nvim-highlight-colors` paints hex, rgb, hsl, ANSI, and CSS variable colors as backgrounds. Tailwind is off.
  - Neovim's LSP document colors are turned off, so colors aren't painted twice.

Comment: In future, I will fix the issue related to the `TodoQuickFix`. For now, nothing is required.

## 5 Code smarts

### 5.1 Language servers

- Mason + `mason-tool-installer` install on start, never auto-update:
  - Servers: `lua-language-server`, `vtsls`, `eslint-lsp`, `oxlint`, `tailwindcss-language-server`, `css-lsp`, `rust-analyzer`, `copilot-language-server`
  - Formatters: `prettier`, `prettierd`, `oxfmt`, `stylua`, `shfmt`
- `nvim-lspconfig` supplies defaults. Servers are turned on with `vim.lsp.enable`: `eslint`, `oxlint`, `lua_ls`, `cssls`, `vtsls`, `tailwindcss`, `rust_analyzer`
- Every server gets file-rename support (`didRename` / `willRename`)

### 5.2 Diagnostics look

- Underlined, not updated while typing, sorted by severity.
- Inline text: `* message`, with the source only when there are several.
- Gutter icons come from the shared icon set.

### 5.3 Per-server settings

- Per-erver settings live in `after/lsp/<name>.lua`.
  - Neovim 0.12 merges these automatically, so there' no setup boilerplate.
- vtsls:
  - Uses the workspace Typerscript and updates imports on file move.
  - Sever-side fuzzy matching and function-call completion.
  - Inlay hints are short: no variable types, **30** characters max.
- lua-l: knows the Neovim runtime, shows param-type hints, silences a few noisy checks.
- cssls: ignores empty rules.
- oxlint: starts with `oxlint --lsp`

### 5.4 Completion

- `blink.cmp`, version `^1`, `enter` preset : Enter accepts.
- Every language server from 5.1 also gets `blink.cmp's completion capabilities.
- Auto brackets after functions. Docs pop up after **200**.
- Menu items are colorized by `Treesitter`, with kind icons from the shared icon set.
- Gohst text is **off**.
  - Copilot already shows inline suggestions, and two ghost texts would clash.
- In the command line, the menu opens by itself for `:` commands only, with nothing preselected.
- `:ToggleCompletion` turns completion off or on for the current buffer. `:ToggleCompletion!` does it for every buffer.
  - Some file types, like `.mdx`, complete in odd ways.
  - Completion runs only when both the buffer and the global switch are on.

### 5.5 Pairs

- mini.pairs with defaults, in insert and command mode.

### 5.6 Formatting

- `conform.nvim` formats on save with a **1000ms** timeout, falling back to the LSP.
- Web files (js, ts, jsx, tsx, json, css, scss, less, html, markdown, mdx, yaml): oxfmt, then prettierd, then prettier, using the first available.
  - oxfmt runs only when the project h as an oxfmt config, like `.oxfmtrc.json` or a Vite+ `vite.config.ts`, so projects using prettier keep their own formatter.
  - A `vite.config.ts` counts only when it has a `fmt` section, so plain Vite projects keep prettier.
  - `.mdx` files get the `mdx` filetype, which Neovim doesn't detect on its own.
- lua: stylua.sh: shfmt.
- `:ToggleFormatter` turns format-on-save off or back on for the current buffer, with a nofication. The command lives in `config/commands.lua`

### 5.7 LSP keymaps

| Keys                   | Action                                                          | Notes                                                                                     |
| ---------------------- | --------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `gd`                   | Go to definition                                                | Through the picker, like `gD`, `gt`, and `gr`.                                            |
| `gD`                   | Goes to the declaration                                         | -                                                                                         |
| `gt`                   | Go to type definition                                           | Replaces "next tab", which stays on `Tab` and `<leader>tn`. Built-in: `grt`.              |
| `gr`                   | List references                                                 | Fires instantly; the built-in `grn`, `gra`, `grr`, `gri`, `grt`, `grx` keys are not used. |
| `gI`                   | Goes to the source definition in TypeScript, the implementation | -                                                                                         |
| `;c`                   | Lists incoming calls                                            | -                                                                                         |
| `K`                    | Show type and docs in a float                                   | Built-in. Press `K` again to enter the float and scroll.                                  |
| `gK` / `C-K>` (insert) | Show signature help                                             | -                                                                                         |
| `<leader>ca`           | Shows code actions                                              | -                                                                                         |
| `<leader>cr`           | Renames symbol                                                  | -                                                                                         |
| `<leader>cR`           | Renames the file with import updates                            | -                                                                                         |
| `<leader>f`            | Formats now                                                     | -                                                                                         |
| `<leader>cl`           | Shows LSP info                                                  | -                                                                                         |
| `E`                    | Show the error under the cursor in a float                      | Replaces "jump to end of WORD". Built-in: `<C-w>d`.                                       |
| `gO`                   | List symbols in the file                                        | Built-in.                                                                                 |
| `<C-s>`                | Show function parameters while typing arguments                 | Built-in, insert mode.                                                                    |
| `]d` / `[d`            | Next / previous diagnostic                                      | Built-in.                                                                                 |
| `]D` / `[D`            | Last / first diagnostic                                         | Built-in.                                                                                 |
| `;e`                   | List all diagnostics in a picker                                | From 3.1.                                                                                 |
| `<C-o>` / `<C-t>`      | Jump back                                                       | Built-in. `<C-o>` after any jump, `<C-t>` after `<C-]>`.                                  |

## 6. Git

### 6.1 Signs and boilerplate

- `gitsigns.nvim` with defaults.

| Keys         | Action                                                                   | Notes                                                       |
| ------------ | ------------------------------------------------------------------------ | ----------------------------------------------------------- |
| `<leader>gb` | blames the line                                                          | -                                                           |
| `<leader>gB` | blames the buffer                                                        | -                                                           |
| `<leader>go` | Opens the file as of the commit that last touched the line, in a new tab | Shows the next of an old change without leaving the editor. |
| `<leader>gs` | Stages the buffer, or unstages it if nothing is left to stage            | -                                                           |
| `<leader>gh` | Stages or unstages the hunk                                              | -                                                           |
| `]h` / `[h`  | Goes to the next / previous hunk                                         | -                                                           |

### 6.2 Diff view

- `codediff.nvim` for side-by-side diffs and history
  - Useful when agents make a lot of changes in the codebase
- Explorer: **tree** view, **50** columns wide, opens files as the cursor moves, shows +/- line stats.
- Compact mode: only changes plus **0** context lines, with folds synced accross panes.

| Keys         | Action                           | Notes |
| ------------ | -------------------------------- | ----- |
| `<leader>dv` | Toggles the diff view            | -     |
| `<leader>dh` | Shows the current file's history | -     |
| `<leader>dH` | Shows the repo history           | -     |

Comment: `<leader>d` (delete without copying, 1.8) now waits for `v`, `h`, or `H`. I will revisit it later. For now, nothing is required.

### 6.3 lazygit

- `;g` opens lazygit in a float through `snacks.nvim` with the theme synced and the active border in the WarningMsg color.
- Pressing `e` on a file closes lazygit and opens the file in the window if was launched from, through `$NVIM` and `nvim --server --remote`.
  - `;g` remembers the current window. `e` quits lazygit, focuses that window with `--remote-send`, then opens the file, so the cursor ends up in the file.
  - Not a new tab and not a nested Neovim. Outside Neovim it jsut runs `nvim <file>`.
- Diffs render with `delta --dark --paging=nefver --syntax-theme="Solarized (dark)"`.
- Mouse events are off and auto-fetch is off.
- `C` in the files panel commits with commitizen (`git cz`)

Comment: In future, `~/.config/lazygit/config.yml` will be added, and the lazygit settings above can move there. For now, nothing is required.

## 7 Agentic coding

### 7.1 Copy paths for agents

| Keys | Action | Notes |
| ---- | ------ | ----- |

## 7 Agentic coding

### 7.1 Copy paths for agents

| Keys         | Action                                                       | Notes                                     |
| ------------ | ------------------------------------------------------------ | ----------------------------------------- |
| `<leader>li` | Copes the current file's path relative to cwd with `#L<line` | e.g., `lua/turalowski/plugins/ui.lua#L11` |
| `<leader>fi` | Copies the absolute path the same way                        | -                                         |

- Both show the copied text in a notification.
  - Pasting the path into an agent's promp points it at the exact line.
