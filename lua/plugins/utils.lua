return {

	-- Automatic tabstop and shift width
	{ "tpope/vim-sleuth" },

	{ -- Undotree
		"mbbill/undotree",
		event = "BufReadPre",
		vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "[U]ndotree Toggle" }),
	},

	{ -- "gc" to comment visual regions/lines
		"numToStr/Comment.nvim",
		event = "BufReadPre",
		opts = {},
	},

	{ -- Automatic closing bracket and tags pairs based on rules

		{ -- For auto brackets and quotes
			"windwp/nvim-autopairs",
			event = "InsertEnter",

			config = function()
				local npairs = require("nvim-autopairs")
				local Rule = require("nvim-autopairs.rule")

				npairs.setup({

					enable_check_bracket_line = false,

					check_ts = true,
					ts_config = {
						lua = { "string" }, -- it will not add a pair on that treesitter node
						javascript = { "template_string" },
					},

					fast_wrap = {
						map = "<a-e>",
						chars = { "{", "[", "(", '"', "'" },
						pattern = [=[[%'%"%>%]%)%}%,]]=],
						end_key = "$",
						before_key = "h",
						after_key = "l",
						cursor_pos_before = true,
						keys = "qwertyuiopzxcvbnmasdfghjkl",
						manual_position = true,
						highlight = "Search",
						highlight_grey = "Comment",
					},
				})

				local ts_conds = require("nvim-autopairs.ts-conds")

				-- press % => %% only while inside a comment or string
				npairs.add_rules({
					Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
					Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
				})

				require("nvim-ts-autotag").setup({})
			end,
		},

		{ -- Auto tags for html
			"windwp/nvim-ts-autotag",
			event = "InsertEnter",
			filetype = {
				"html",
				"js",
				"ts",
				"jsx",
				"tsx",
			},

			config = function()
				require("nvim-ts-autotag").setup({

					opts = {
						-- Defaults
						enable_close = true, -- Auto close tags
						enable_rename = true, -- Auto rename pairs of tags
						enable_close_on_slash = false, -- Auto close on trailing </
					},
				})
			end,
		},
	},

	{ -- Mini nvim collection
		"echasnovski/mini.nvim",
		event = "BufRead",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - ;saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - ;sd'   - [S]urround [D]elete [']quotes
			-- - ;sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup({
				mappings = {
					add = ";sa", -- Add surrounding in Normal and Visual modes
					delete = ";sd", -- Delete surrounding
					find = ";sf", -- Find surrounding (to the right)
					find_left = ";sF", -- Find surrounding (to the left)
					highlight = ";sh", -- Highlight surrounding
					replace = ";sr", -- Replace surrounding
					update_n_lines = ";sn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
			})

			-- Quicker movement with brackets
			require("mini.bracketed").setup({
				--   Supply empty string `''` to not create mappings.
				-- See `:h MiniBracketed.config` for more info.
				buffer = { suffix = "b", options = {} }, -- Buffer
				comment = { suffix = "c", options = {} }, -- Comment Block
				conflict = { suffix = "x", options = {} }, -- Conflict Marker
				diagnostic = { suffix = "d", options = {} }, -- Diagnostic
				file = { suffix = "f", options = {} }, -- File on Disk
				indent = { suffix = "i", options = {} }, -- Indent Change
				jump = { suffix = "j", options = {} }, -- Jump from jumplist inside current buffer
				location = { suffix = "l", options = {} }, -- Location from location list
				oldfile = { suffix = "o", options = {} }, -- Old files
				quickfix = { suffix = "q", options = {} }, -- Quickfix entries from quickfix list
				treesitter = { suffix = "t", options = {} }, -- Tree-sitter node and parent
				undo = { suffix = "u", options = {} }, -- Undo states from specially tracked linear history
				window = { suffix = "w", options = {} }, -- Window in current tab
				yank = { suffix = "y", options = {} }, -- Yank selection replacing latest put region
			})

			-- Move visual blocks with ALT + {h,j,k,l}
			require("mini.move").setup()

			-- Split or join with gS
			require("mini.splitjoin").setup()
		end,
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()

			require("which-key").add({
				{ "<leader>c", desc = "[C]ode" },
				{ "<leader>d", desc = "[D]ocument" },
				{ "<leader>r", desc = "[R]ename" },
				{ "<leader>s", desc = "[S]earch" },
				{ "<leader>w", desc = "[W]orkspace" },
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	{ -- Persist sessions
		"folke/persistence.nvim",
		event = "BufReadPre",
		cmd = "Lua require('persistence).load()",

		opts = {
			dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
			options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
			pre_save = nil, -- a function to call before saving the session
			post_save = nil, -- a function to call after saving the session
			save_empty = false, -- don't save if there are no open file buffers
			pre_load = nil, -- a function to call before loading the session
			post_load = nil, -- a function to call after loading the session
		},

		vim.api.nvim_set_keymap(
			"n",
			"<leader>Ss",
			[[<cmd>lua require("persistence").load()<cr>]],
			{ desc = "Load session" }
		),
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Sl",
			[[<cmd>lua require("persistence").load({ last = true })<cr>]],
			{ desc = "Load last session" }
		),
		vim.api.nvim_set_keymap(
			"n",
			"<leader>Sd",
			[[<cmd>lua require("persistence").stop()<cr>]],
			{ desc = "Pause persistence" }
		),
	},

	{ -- Nvim markdown preview
		"OXY2DEV/markview.nvim",
		ft = "markdown",

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ -- Markdown previewing in browser
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = "markdown",

		build = function()
			vim.fn["mkdp#util#install"]()
		end,

		config = function()
			vim.cmd([[do FileType]])
			vim.cmd([[
			function OpenMarkdownPreview (url)
			let cmd = "surf -bdfIK " . shellescape(a:url) . " &"
			silent call system(cmd)
			endfunction
			]])
			vim.g.mkdp_browserfunc = "OpenMarkdownPreview"

			vim.g.mkdp_open_ip = "127.0.0.1"
			vim.g.mkdp_port = 6942
		end,

		vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true }),
	},

	{ -- Macro repository to save macros
		"chamindra/marvim",
		event = "BufReadPre",
	},

	{ -- fzf-lua
		"ibhagwan/fzf-lua",
		event = "BufReadPre",
		config = function()
			require("fzf-lua").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},

	{ -- Local configs
		"klen/nvim-config-local",
		config = function()
			require("config-local").setup({
				-- Default options (optional)

				-- Config file patterns to load (lua supported)
				config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

				-- Where the plugin keeps files data
				hashfile = vim.fn.stdpath("data") .. "/config-local",

				autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
				commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
				silent = false, -- Disable plugin messages (Config loaded/denied)
				lookup_parents = false, -- Lookup config files in parent directories
			})
		end,
	},
}
