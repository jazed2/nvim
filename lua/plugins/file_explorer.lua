return {

	{ -- Oil
		"stevearc/oil.nvim",
		opts = {
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				-- This function defines what is considered a "hidden" file
				is_hidden_file = function(name, bufnr)
					return vim.startswith(name, ".")
				end,
				natural_order = true,
			},
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	},

	{ -- NeoTree
		"nvim-neo-tree/neo-tree.nvim",
		event = "BufRead",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader><TAB>", ":Neotree reveal<CR>", desc = "NeoTree reveal" },
		},
		opts = {
			filesystem = {
				window = {
					mappings = {
						["<leader><TAB>"] = "close_window",
					},
				},
			},
		},
	},
}
