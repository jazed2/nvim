return {
	-- Git related plugins
	{ "tpope/vim-fugitive", "tpope/vim-rhubarb" },

	{ -- LazyGit integration with Telescope
		"kdheepak/lazygit.nvim",
		keys = {
			{
				"<leader>lg",
				":LazyGit<Return>",
				desc = "Lazy git UI",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
}
