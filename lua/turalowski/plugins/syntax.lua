-- nvim-treesitter (main branch): install these parsers. Missing ones are built in the
-- background; already installed ones are skipped.
require("nvim-treesitter").install({
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"fish",
	"gitignore",
	"go",
	"graphql",
	"html",
	"http",
	"java",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"php",
	"printf",
	"python",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"svelte",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
})

-- Start Treesitter highlighting and indent for any filetype that has a parser.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("turalowski_treesitter", { clear = true }),
	desc = "Start Treesitter highlighting and indent",
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang or not vim.treesitter.language.add(lang) then
			return
		end
		vim.treesitter.start(ev.buf, lang)
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Highlight TODO, FIXME, HACK, NOTE and the like in comments.
require("todo-comments").setup()

-- Paint color codes (hex, rgb, hsl, ANSI, CSS variables) with their own color as background.
require("nvim-highlight-colors").setup({
	render = "background",
	enable_tailwind = false,
})
-- Turn off Neovim's LSP document colors, so colors are not painted twice.
vim.lsp.document_color.enable(false)
