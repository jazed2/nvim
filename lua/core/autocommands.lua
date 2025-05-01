local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", { -- Highlight when yanking (copying) text
	desc = "Highlight when yanking (copying) text",
	group = augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd({ "BufWinLeave" }, { -- Save folds
	pattern = { "*.*" },
	desc = "Save folds when exiting",
	command = "mkview",
})

autocmd({ "BufWinEnter" }, { -- Reload folds
	pattern = { "*.*" },
	desc = "Load folds when entering",
	command = "silent! loadview",
})

autocmd("BufWinEnter", { -- Open :h in vertical split on right
	group = augroup("help_window_right", {}),
	pattern = { "*.txt" },
	callback = function()
		if vim.o.filetype == "help" then
			vim.cmd([[
        wincmd L
        vertical resize 90
      ]])
		end
	end,
})
