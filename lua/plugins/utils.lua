return {

	"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically

	{ -- Undotree
		"mbbill/undotree",
		event = "BufReadPre",
		vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "[U]ndotree Toggle" }),
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
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
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
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

	{ -- Macro repository to save macros
		"kr40/nvim-macros",
		cmd = { "MacroSave", "MacroYank", "MacroSelect", "MacroDelete" },
		config = function()
			require("macros").setup({
				json_file_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/macros.json"),
				default_macro_register = "q",
				json_formatter = "jq",
			})
		end,
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
}
