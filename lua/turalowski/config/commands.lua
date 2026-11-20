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

-- :FixTypos sends the buffer (or a range) to Claude Code and replaces it with a
-- typo-fixed version. The edit is one undo step, so `u` reverts it.
local fix_typos_prompt = [[
You are a proofreader. Fix spelling mistakes and obvious typos in the text you are given.
Do not change wording, grammar, style, punctuation, formatting, whitespace, indentation,
code, identifiers, URLs, or anything that is not a typo.
Output only the corrected text, exactly once, with no explanation and no code fences.
If there is nothing to fix, output the text unchanged.]]

vim.api.nvim_create_user_command("FixTypos", function(opts)
	if vim.fn.executable("claude") == 0 then
		vim.notify("FixTypos: `claude` is not on PATH.", vim.log.levels.ERROR)
		return
	end

	local buf = vim.api.nvim_get_current_buf()
	local first, last = opts.line1 - 1, opts.line2
	local input = table.concat(vim.api.nvim_buf_get_lines(buf, first, last, false), "\n")
	if input:match("^%s*$") then
		return
	end
	local tick = vim.api.nvim_buf_get_changedtick(buf)

	vim.notify("FixTypos: checking…")
	vim.system({
		"claude", "-p",
		"--model", "sonnet",
		"--tools", "",
		"--system-prompt", fix_typos_prompt,
		"--no-session-persistence",
	}, { stdin = input, text = true }, vim.schedule_wrap(function(res)
		if res.code ~= 0 then
			vim.notify("FixTypos failed: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
			return
		end
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		if vim.api.nvim_buf_get_changedtick(buf) ~= tick then
			vim.notify("FixTypos: buffer changed while checking; not applying.", vim.log.levels.WARN)
			return
		end

		local output = (res.stdout or ""):gsub("\n+$", "")
		output = output:gsub("^```[%w]*\n", ""):gsub("\n```$", "")
		if output == input then
			vim.notify("FixTypos: no typos found.")
			return
		end

		local views = {}
		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
		end
		vim.api.nvim_buf_set_lines(buf, first, last, false, vim.split(output, "\n", { plain = true }))
		for win, view in pairs(views) do
			vim.api.nvim_win_call(win, function()
				vim.fn.winrestview(view)
			end)
		end
		vim.notify("FixTypos: done (press u to undo).")
	end))
end, { range = "%", desc = "Fix typos in buffer or range with Claude" })
