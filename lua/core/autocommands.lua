-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Preserve folds in between sessions
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufEnter" }, {
	pattern = { "*.*" },
	desc = "Save folds when exiting",
	command = "mkview 1",
})
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufRead" }, {
	pattern = { "*.*" },
	desc = "Load folds when entering",
	command = "silent! loadview 1",
})
