return {
	{ -- alabaster
		"p00f/alabaster.nvim",
		lazy = false,
		priority = 1000,
	},

	{ -- true-monochrome
		"ryanpcmcquen/true-monochrome_vim",
		lazy = false,
		priority = 1000,
	},

	{ -- rasmus
		"kvrohit/rasmus.nvim",
		lazy = false,
		priority = 1000,
	},

	{
		"aktersnurra/no-clown-fiesta.nvim",
		lazy = false,
		priority = 100,
		config = function()
			require("no-clown-fiesta").setup({
				styles = {
					-- You can set any of the style values specified for `:h nvim_set_hl`
					comments = {},
					functions = {},
					keywords = {},
					lsp = {},
					match_paren = {},
					type = {},
					variables = {},
				},
			})
		end,
	},
}
