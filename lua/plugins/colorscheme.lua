return {
	{
		"Mofiqul/adwaita.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		lazy = false,
		event = "VimEnter",
		-- configure and set on startup
		config = function()
			vim.g.adwaita_darker = false -- for darker version
			vim.g.adwaita_transparent = false -- makes the background transparent
			vim.cmd.colorscheme("adwaita")
		end,
	},

	{
		"bluz71/vim-moonfly-colors",
		enabled = false,
	},

	{
		"savq/melange-nvim",
		enabled = false,
	},

	{
		"comfysage/evergarden",
		opts = {
			contrast_dark = "hard", -- 'hard'|'medium'|'soft'
			overrides = {}, -- add custom overrides
		},
		enabled = false,
	},
}
