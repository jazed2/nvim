local opt = vim.opt
-- [[ Setting options ]]
-- See `:help opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Nice tab spacing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 4

-- Make line numbers default
opt.relativenumber = true
opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
opt.showmode = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard = "unnamedplus"

-- Some indent option
opt.breakindent = true
opt.autoindent = true
opt.smartindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "cursor" -- Preserve cursor position

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = false

-- termgui colors
opt.termguicolors = true

-- Set filename as buffer title
opt.title = true

-- Backspace to clear indents
opt.backspace = { "start", "eol", "indent" }

-- Easier file search
opt.path:append({ "**" })
