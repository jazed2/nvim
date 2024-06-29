return {
	{ -- Nvim Tmux navigation
		"alexghergh/nvim-tmux-navigation",
		event = "VimEnter",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},

	{ -- File and buffer bookmarks
		"otavioschwanck/arrow.nvim",
		event = "BufEnter",
		opts = {
			show_icons = true,
			leader_key = "\\", -- Recommended to be a single key
			buffer_leader_key = "m", -- Per Buffer Mappings
		},
	},

	{ -- Enhanced f/t motions for Leap
		"ggandor/flit.nvim",
		event = "BufRead",
		dependencies = {
			"ggandor/leap.nvim",
			keys = {
				{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
				{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
				{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
			},
			config = function(_, opts)
				local leap = require("leap")
				for k, v in pairs(opts) do
					leap.opts[k] = v
				end
				leap.add_default_mappings(true)
				vim.keymap.del({ "x", "o" }, "x")
				vim.keymap.del({ "x", "o" }, "X")
			end,
		},
		keys = function()
			---@type LazyKeys[]
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
}
