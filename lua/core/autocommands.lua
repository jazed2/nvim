local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", { -- Highlight when yanking (copying) text
	desc = "Highlight when yanking (copying) text",
	group = augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd({ "BufWinLeave", "BufEnter" }, { -- Save folds
	pattern = { "*.*" },
	desc = "Save folds when exiting",
	command = "mkview 1",
})

autocmd({ "BufWinEnter", "BufRead" }, { -- Reload folds
	pattern = { "*.*" },
	desc = "Load folds when entering",
	command = "silent! loadview 1",
})
