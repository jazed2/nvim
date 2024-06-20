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
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Better bracket movement
			require("mini.bracketed").setup()

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

	{ -- Create, manage, delete neovim session
		"gennaro-tedesco/nvim-possession",
		dependencies = {
			"ibhagwan/fzf-lua",
		},
		config = true,
		init = function()
			local possession = require("nvim-possession")
			vim.keymap.set("n", "<leader>kl", function()
				possession.list()
			end, { desc = "List Sessions" })
			vim.keymap.set("n", "<leader>kn", function()
				possession.new()
			end, { desc = "Create new session" })
			vim.keymap.set("n", "<leader>ku", function()
				possession.update()
			end, { desc = "Update current session, if new buffers are open" })
			vim.keymap.set("n", "<leader>kd", function()
				possession.delete()
			end, { desc = "Delete current session" })
		end,
	},

	{ -- Obsidian nvim integration
		"epwalsh/obsidian.nvim",
		version = "*",
		ft = "markdown",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"iBhagwan/fzf-lua",
			"nvim-treesitter",
		},

		opts = {
			workspaces = {
				-- {
				-- 	name = "C_vault",
				-- 	path = "~/repos/study/C-lang/C_vault",
				-- },

				{
					name = "no-vault",
					path = function()
						return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
					end,
					overrides = {
						notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
						new_notes_location = "current_dir",
						templates = {
							folder = vim.NIL,
						},
						disable_frontmatter = true,
					},
				},
			},

			mappings = {
				[";fl"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},

				["<cr>"] = {
					action = function()
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},

			open_app_foreground = false,

			picker = {
				name = "fzf-lua",
				mappings = {
					new = "<C-x>",
					insert_link = "<C-l>",
				},
			},

			---@param url string
			follow_url_func = function(url)
				vim.fn.jobstart({ "xdg-open", url })
			end,

			ui = {
				enable = true, -- set to false to disable all additional syntax features
				update_debounce = 200, -- update delay after a text change (in milliseconds)
				max_file_length = 5000, -- disable UI features for files with more than this many lines
				-- Define how various check-boxes are displayed
				checkboxes = {
					-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
					[" "] = { char = "󰄱 ", hl_group = "ObsidianTodo" },
					["x"] = { char = " ", hl_group = "ObsidianDone" },
					[">"] = { char = " ", hl_group = "ObsidianRightArrow" },
					["~"] = { char = "󰰱 ", hl_group = "ObsidianTilde" },
					["!"] = { char = " ", hl_group = "ObsidianImportant" },
					-- You can also add more custom ones...
				},
				-- Use bullet marks for non-checkbox lists.
				bullets = { char = "", hl_group = "ObsidianBullet" },
				external_link_icon = { char = " ", hl_group = "ObsidianExtLinkIcon" },
				-- Replace the above with this if you don't have a patched font:
				-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
				reference_text = { hl_group = "ObsidianRefText" },
				highlight_text = { hl_group = "ObsidianHighlightText" },
				tags = { hl_group = "ObsidianTag" },
				block_ids = { hl_group = "ObsidianBlockID" },
				hl_groups = {
					-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
					ObsidianTodo = { bold = true, fg = "#f78c6c" },
					ObsidianDone = { bold = true, fg = "#89ddff" },
					ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
					ObsidianTilde = { bold = true, fg = "#ff5370" },
					ObsidianImportant = { bold = true, fg = "#d73128" },
					ObsidianBullet = { bold = true, fg = "#89ddff" },
					ObsidianRefText = { underline = true, fg = "#c792ea" },
					ObsidianExtLinkIcon = { fg = "#c792ea" },
					ObsidianTag = { italic = true, fg = "#89ddff" },
					ObsidianBlockID = { italic = true, fg = "#89ddff" },
					ObsidianHighlightText = { bg = "#75662e" },
				},
			},
		},
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
}
