return {
	"stevearc/oil.nvim",
	opts = {
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
		},
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
}
