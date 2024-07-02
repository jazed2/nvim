return {

	"nvim-neorg/neorg",
	filetype = "norg",
	version = "*",

	dependencies = { -- Neorg pre-requisite
		"vhyrro/luarocks.nvim",
		priority = 1000, -- We'd like this plugin to load first out of the rest
		config = true, -- This automatically runs `require("luarocks-nvim").setup()`
	},

	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				-- ["core.dirman"] = {
				-- 	config = {
				-- 		workspaces = {
				-- 			notes = "~/notes",
				-- 		},
				-- 		default_workspace = "notes",
				-- 	},
				-- },
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
