return {

	{ -- Collection of various small independent plugins/modules
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
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Minimal file explorer
			require("mini.files").setup({
				vim.keymap.set("n", "-", ":lua MiniFiles.open()<cr>", { noremap = true, silent = true }),
				config = function() end,
			})

			-- Better bracket movement
			require("mini.bracketed").setup()

			-- Move visual blocks with ALT + {h,j,k,l}
			require("mini.move").setup()

			-- Automatically add closing bracket/quote
			require("mini.pairs").setup()

			-- Split or join with gS
			require("mini.splitjoin").setup()
		end,
	},
}
