return {
	-- Automatic tabstop and shift width
	{ "tpope/vim-sleuth" },

	-- Undotree
	{ "mbbill/undotree", vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" }) },

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	{ -- Mini nvim collection
		"echasnovski/mini.nvim",
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
			-- - ysaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - ysd'   - [S]urround [D]elete [']quotes
			-- - ysr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup({
				mappings = {
					add = "ysa", -- Add surrounding in Normal and Visual modes
					delete = "ysd", -- Delete surrounding
					find = "ysf", -- Find surrounding (to the right)
					find_left = "ysF", -- Find surrounding (to the left)
					highlight = "ysh", -- Highlight surrounding
					replace = "ysr", -- Replace surrounding
					update_n_lineys = "ysn", -- Update `n_lines`

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
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
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

		opts = {
			dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
			options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
			pre_save = nil, -- a function to call before saving the session
			post_save = nil, -- a function to call after saving the session
			save_empty = false, -- don't save if there are no open file buffers
			pre_load = nil, -- a function to call before loading the session
			post_load = nil, -- a function to call after loading the session
		},

		vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {}),
		vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {}),
		vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {}),
	},

	{ -- Markdown previewing in browser
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },

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

	{ -- Markdown preview in terminal
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		ft = "markdown",

		config = function()
			require("glow").setup({
				border = "shadow", -- floating window border config
				style = "dark", -- filled automatically with your current editor background, you can override using glow json style
				pager = true,
				width = 1200,
				height = 1200,
			})
		end,
	},

	{ -- Spawn floating terminal inside nvim
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-t>]],
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = false,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},
}
