return {
	{
		"sam4llis/nvim-tundra",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.g.tundra_biome = "arctic" -- 'arctic' or 'jungle'
			vim.opt.background = "dark"

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
}
