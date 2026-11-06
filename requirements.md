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
    
