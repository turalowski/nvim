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
    -  Faster CursorHold events, and key sequences resolve without lag.

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
        - With `cmdheight` 0 the command line needs somewhere to appear, and near the top is where  the eyes already are.

### 1.7 Autocmds

- Yanked text flashes briefly.
- Only the active window shows the cursorline.

### 1.8 Core Keymaps

| Keys | Action | Notes |
| ---  | ----- | ----- |
| 'x' | Deletes without copying | - |  
| `<leader>nh` | Clear search highlights | - | 
| `<leader>d`, `<leader>c`, `<leader>p` | Delete, change, and paste without touching the yank | The yanked text stays safe while editing around it. |
| `dw` | Deletes the word backwards without copying | - | 
| `+` / `-` | Increment and decrement numbers | - |
| `<C-a>` | Selects all | - | 
| `<leader>to`, `<leader>tx`, `<leader>tn` / `Tab`, `<leader>tp` / `Shift-Tab`, `<leader>tf` | Open new tab, Close current tab, Go next tab, To to previous tab, Open current buffer in new tab | - |
| `<leader>sv`, `<leader>ss`, `<leader>se`, `<leader>sx` | Split vertical, Split horizontal, Make splits equal size, Close current split | - |
| `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` | Move between windows | - | 
| `<C-d>` | Keep cursor in the middle on page down | - |
| `<C-u>` | Keep cursor in the middle on page up | - |
| `n` | Keep cursor in the middle on highlight of next search item | - |
| `N` | Keep cursor in the middle on highlight previous search item | - | 
| `<C-m>` | Jumps forward in the jump list | - |
| `<leader>o` / `<leader>O` | Open a line below or above without continuing a comment | - | 
| `<leader>up` | Fast commit and push: asks for a message, then runs `git add .`, a signed `git commit -S`, and `git push` | Aborts when the message is empty. |
| `<leader>li` | Copy the file path and line number to the system clipboard, as `path:Lline` | - |
| `<leader>bx`, `<leader>bn`, `<leader>bp`, `<leader>bd` | Close current buffer, Go to next buffer, Go to previous buffer, Closes every hidden buffer, except unsaved ones. | - |
| `<leader>R` | Reload files changed on disk | - | 

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
- Smooth scroll is *off**.
    - Scrolling should feel instant.

## 3. Navigating

### 3.1 Picker

- `snacks.nvim` picker.

| Keys | Action | Comment |
| --- | --- | --- | 
| `:f` | Finds files, including hidden ones | Dotfiles like `.github/` and `.env.example` are part ofd real projects | - | 
| `;r` | Live-greps, including hidden files | - | 
| `;;` | Reopens the last picker | - | 
| `\\` | Lists open buffers | Jumps to a window that already shows the buffer. | 
| `;e` | Lists diagnostics | - | 
| `;n` | Shows notifications | - | 
| `;h` | Lists git hunks | -  |
