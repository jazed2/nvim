return {
	{
		"Mofiqul/adwaita.nvim",
		lazy = false,
		-- configure and set on startup
		config = function()
			vim.g.adwaita_darker = true -- for darker version
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
