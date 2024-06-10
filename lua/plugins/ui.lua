return {
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = true },
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Nice folding
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",

		config = function()
			local ufo = require("ufo")
			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			ufo.setup({
				open_fold_hl_timeout = 150,
				close_fold_kinds_for_ft = {
					default = { "imports", "comment" },
					c = { "comment", "region" },
				},

				preview = {
					win_config = {
						border = { "", "─", "", "", "", "─", "", "" },
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
						jumpTop = "[",
						jumpBot = "]",
					},
				},

				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,

				fold_virt_text_handler = handler,
				enable_get_fold_virt_text = false,
			})

			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)
			vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
			vim.keymap.set("n", "zm", ufo.closeFoldsWith)
		end,
	},

	{ -- Show line indent
		"lukas-reineke/indent-blankline.nvim",
		event = "VimEnter",
		dependencies = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		main = "ibl",
		opts = {},
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require("ibl.hooks")
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup({ scope = { highlight = highlight } })

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end,
	},

	{ -- LazyGit integration with Telescope
		"kdheepak/lazygit.nvim",
		keys = {
			{
				"<leader>lg",
				":LazyGit<Return>",
				silent = true,
				noremap = true,
			},
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ -- Btter nvim UI
		"stevearc/dressing.nvim",
		opts = {},
		config = function()
			require("dressing").setup({
				input = {
					-- Set to false to disable the vim.ui.input implementation
					enabled = true,

					-- Default prompt string
					default_prompt = "Input",

					-- Trim trailing `:` from prompt
					trim_prompt = true,

					-- Can be 'left', 'right', or 'center'
					title_pos = "left",

					-- When true, <Esc> will close the modal
					insert_only = true,

					-- When true, input will start in insert mode.
					start_in_insert = true,

					-- These are passed to nvim_open_win
					border = "rounded",
					-- 'editor' and 'win' will default to being centered
					relative = "cursor",

					-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					prefer_width = 40,
					width = nil,
					-- min_width and max_width can be a list of mixed types.
					-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
					max_width = { 140, 0.9 },
					min_width = { 20, 0.2 },

					buf_options = {},
					win_options = {
						-- Disable line wrapping
						wrap = false,
						-- Indicator for when text exceeds window
						list = true,
						listchars = "precedes:…,extends:…",
						-- Increase this for more context when text scrolls off the window
						sidescrolloff = 0,
					},

					-- Set to `false` to disable
					mappings = {
						n = {
							["<Esc>"] = "Close",
							["<CR>"] = "Confirm",
						},
						i = {
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
							["<Up>"] = "HistoryPrev",
							["<Down>"] = "HistoryNext",
						},
					},

					override = function(conf)
						-- This is the config that will be passed to nvim_open_win.
						-- Change values here to customize the layout
						return conf
					end,

					-- see :help dressing_get_config
					get_config = nil,
				},
				select = {
					-- Set to false to disable the vim.ui.select implementation
					enabled = true,

					-- Priority list of preferred vim.select implementations
					backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

					-- Trim trailing `:` from prompt
					trim_prompt = true,

					-- Options for telescope selector
					-- These are passed into the telescope picker directly. Can be used like:
					-- telescope = require('telescope.themes').get_ivy({...})
					telescope = nil,

					-- Options for fzf selector
					fzf = {
						window = {
							width = 0.5,
							height = 0.4,
						},
					},

					-- Options for fzf-lua
					fzf_lua = {
						-- winopts = {
						--   height = 0.5,
						--   width = 0.5,
						-- },
					},

					-- Options for nui Menu
					nui = {
						position = "50%",
						size = nil,
						relative = "editor",
						border = {
							style = "rounded",
						},
						buf_options = {
							swapfile = false,
							filetype = "DressingSelect",
						},
						win_options = {
							winblend = 0,
						},
						max_width = 80,
						max_height = 40,
						min_width = 40,
						min_height = 10,
					},

					-- Options for built-in selector
					builtin = {
						-- Display numbers for options and set up keymaps
						show_numbers = true,
						-- These are passed to nvim_open_win
						border = "rounded",
						-- 'editor' and 'win' will default to being centered
						relative = "editor",

						buf_options = {},
						win_options = {
							cursorline = true,
							cursorlineopt = "both",
						},

						-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
						-- the min_ and max_ options can be a list of mixed types.
						-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
						width = nil,
						max_width = { 140, 0.8 },
						min_width = { 40, 0.2 },
						height = nil,
						max_height = 0.9,
						min_height = { 10, 0.2 },

						-- Set to `false` to disable
						mappings = {
							["<Esc>"] = "Close",
							["<C-c>"] = "Close",
							["<CR>"] = "Confirm",
						},

						override = function(conf)
							-- This is the config that will be passed to nvim_open_win.
							-- Change values here to customize the layout
							return conf
						end,
					},

					-- Used to override format_item. See :help dressing-format
					format_item_override = {},

					-- see :help dressing_get_config
					get_config = nil,
				},
			})
		end,
	},

	{ -- File explorer
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

	{ -- ZenMode
		"folke/zen-mode.nvim",
		dependencies = "folke/twilight.nvim",
		vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { noremap = true, silent = true }),
		opts = {
			window = {
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorcolumn = false,
					foldcolumn = "0",
				},
			},
			plugins = {
				alacritty = { enabled = true, font = "10" },
				tmux = { enabled = false },
			},
			-- callback where you can add custom code when the Zen window opens
			-- No need to add *on_close* callback to reload folds
			on_open = function(win)
				vim.cmd("%foldopen")
			end,
		},
	},
}
