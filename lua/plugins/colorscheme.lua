return {
	{
		"Mofiqul/adwaita.nvim",
		lazy = false,
		priority = 1200,
		-- configure and set on startup
		config = function()
			vim.g.adwaita_darker = true -- for darker version
			vim.g.adwaita_transparent = true -- makes the background transparent
			vim.cmd.colorscheme("adwaita")
		end,
	},
}
