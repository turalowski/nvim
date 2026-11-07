-- One group for all autocmds here. clear = true removes old copies when this file is reloaded.
local group = vim.api.nvim_create_augroup("turalowski", { clear = true })

-- After a yank, briefly highlight the yanked text so you can see what was copied.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Flash yanked text",
	callback = function()
		vim.hl.on_yank()
	end,
})

-- When you move into a window, turn its cursorline on.
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = group,
	desc = "Show cursorline in the active window",
	callback = function()
		vim.wo.cursorline = true
	end,
})

-- When you move out of a window, turn its cursorline off, so only the active window shows it.
vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	desc = "Hide cursorline in inactive windows",
	callback = function()
		vim.wo.cursorline = false
	end,
})
