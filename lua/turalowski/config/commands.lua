-- :ToggleCompletion turns completion off/on for the current buffer.
-- :ToggleCompletion! turns it off/on for every buffer.
vim.api.nvim_create_user_command("ToggleCompletion", function(opts)
	local scope = opts.bang and vim.g or vim.b
	scope.completion = scope.completion == false
	local where = opts.bang and "all buffers" or "this buffer"
	vim.notify(("Completion %s for %s."):format(scope.completion and "on" or "off", where))
end, { bang = true, desc = "Toggle completion (! for all buffers)" })

-- :ToggleFormatter turns format-on-save off/on for the current buffer.
vim.api.nvim_create_user_command("ToggleFormatter", function()
	vim.b.disable_autoformat = not vim.b.disable_autoformat
	vim.notify(("Format on save %s for this buffer."):format(vim.b.disable_autoformat and "off" or "on"))
end, { desc = "Toggle format on save for this buffer" })
