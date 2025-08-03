return { -- Mini nvim collection
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - ;saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - ;sd'   - [S]urround [D]elete [']quotes
		-- - ;sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup({
			mappings = {
				add = ";sa", -- Add surrounding in Normal and Visual modes
				delete = ";sd", -- Delete surrounding
				find = ";sf", -- Find surrounding (to the right)
				find_left = ";sF", -- Find surrounding (to the left)
				highlight = ";sh", -- Highlight surrounding
				replace = ";sr", -- Replace surrounding
				update_n_lines = ";sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		})

		-- Quicker movement with brackets
		require("mini.bracketed").setup({
			--   Supply empty string `''` to not create mappings.
			-- See `:h MiniBracketed.config` for more info.
			buffer = { suffix = "b", options = {} }, -- Buffer
			comment = { suffix = "c", options = {} }, -- Comment Block
			conflict = { suffix = "x", options = {} }, -- Conflict Marker
			diagnostic = { suffix = "d", options = {} }, -- Diagnostic
			file = { suffix = "f", options = {} }, -- File on Disk
			indent = { suffix = "i", options = {} }, -- Indent Change
			jump = { suffix = "j", options = {} }, -- Jump from jumplist inside current buffer
			location = { suffix = "l", options = {} }, -- Location from location list
			oldfile = { suffix = "o", options = {} }, -- Old files
			quickfix = { suffix = "q", options = {} }, -- Quickfix entries from quickfix list
			treesitter = { suffix = "t", options = {} }, -- Tree-sitter node and parent
			undo = { suffix = "u", options = {} }, -- Undo states from specially tracked linear history
			window = { suffix = "w", options = {} }, -- Window in current tab
			yank = { suffix = "y", options = {} }, -- Yank selection replacing latest put region
		})

		-- Move visual blocks with ALT + {h,j,k,l}
		require("mini.move").setup()

		-- Split or join with gS
		require("mini.splitjoin").setup()

		-- Auto pairs
		require("mini.pairs").setup()
	end,
}
