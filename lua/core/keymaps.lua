-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Tabs
keymap("n", "tt", ":tabnew .<Return>")
keymap("n", "te", ":tabedit")
keymap("n", "<tab>", ":tabnext<Return>", opts)
keymap("n", "<s-tab>", ":tabprev<Return>", opts)
keymap("n", "tw", ":tabclose<Return>", opts)

-- Fast escape when in Insert mode
keymap("i", "jk", "<esc>", opts)
keymap("i", "kj", "<esc>", opts)

-- Split window
keymap("n", ";S", ":split<Return>", opts)
keymap("n", ";V", ":vsplit<Return>", opts)

-- Resize Splits
keymap("n", "<M-=>", "<C-w>+", opts)
keymap("n", "<M-->", "<C-w>-", opts)
keymap("n", "<M-.>", "<C-w><", opts)
keymap("n", "<M-,>", "<C-w>>", opts)

-- Prevent typo when pressing :w and :wq
vim.cmd([[
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> WQ ((getcmdtype() is# ':' && getcmdline() is# 'WQ')?('wq'):('WQ'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
]])

-- Toggle tabline
vim.opt.showtabline = 0
_G.toggle_tabline = function()
	local showtabline = vim.api.nvim_get_option("showtabline")
	if showtabline > 0 then
		vim.api.nvim_set_option("showtabline", 0) -- disable tabline
	else
		vim.api.nvim_set_option("showtabline", 2) -- always show tabline
	end
end
vim.cmd("command! ToggleTabline lua toggle_tabline()")
keymap("", "<leader>tt", "<cmd>ToggleTabline<cr>", opts)

-- Scroll keybinds
keymap({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Better half up scroll", remap = true })
keymap({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Better half down scroll", remap = true })
keymap("n", "n", "nzzzv", { desc = "Center text when searching", silent = true })
keymap("n", "N", "Nzzzv", { desc = "Center text when searching", silent = true })

-- Fixing bad habits
keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
