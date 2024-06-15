local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" })

return {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	rtp = {
		disabled_plugins = {
			"gzip",
			-- "matchit",
			-- "matchparen",
			"netrwPlugin",
			"rplugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = { notify = false },
	checker = {
		enabled = true, -- automatically check for plugin updates
		notify = false, -- get a notification when new updates are found
	},
}
