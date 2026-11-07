local map = vim.keymap.set

-- Jump between occurrences of the word under the cursor (snacks words).
map("n", "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next occurrence of word" })
map("n", "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous occurrence of word" })
