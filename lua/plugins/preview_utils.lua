return {
	-- Markdown
	{ -- Nvim markdown preview
		"OXY2DEV/markview.nvim",
		ft = "markdown",

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Markdown previewing in browser
		"toppair/peek.nvim",
		ft = "markdown",
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				auto_load = true,
				close_on_bdelete = true,
				syntax = true,
				theme = "dark",
				update_on_change = true,
				app = "qutebrowser",
				throttle_at = 200000,
				throttle_time = "auto",
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

			vim.keymap.set("n", "<leader>pv", "<cmd>PeekOpen<cr>", { desc = "Preview in browser" })
		end,
	},

	{ -- Asciidoc
		"tigion/nvim-asciidoc-preview",
		ft = "asciidoc",
		build = "cd server && npm install --omit=dev",
		opts = {
			server = {
				-- Determines how the AsciiDoc file is converted to HTML for the preview.
				-- `js`  - asciidoctor.js (no local installation needed)
				-- `cmd` - asciidoctor command (local installation needed)
				converter = "js",

				-- Determines the local port of the preview website.
				-- Must be between 10000 and 65535.
				port = 11235,
			},
			preview = {
				-- Determines the scroll position of the preview website.
				-- `current` - Keep current scroll position
				-- `start`   - Start of the website
				-- `sync`    - (experimental) Same (similar) position as in Neovim
				--             => inaccurate, because very content dependent
				position = "current",
			},
		},
		vim.keymap.set("n", "<leader>pv", "<cmd>AsciidocPreview<cr>", { desc = "Preview in browser" }),
	},

	{ -- typst
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {
			dependencies_bin = { ["tinymist"] = "tinymist" },
		}, -- lazy.nvim will implicitly calls `setup {}`
	},

	{ -- CSV visualizing
		"hat0uma/csvview.nvim",
		ft = "csv",
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
		---@module "csvview"
		opts = {
			parser = { comments = { "#", "//" } },
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.
				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
	},
}
