return {
	"hkupty/nvimux",
	config = function()
		local nvimux = require("nvimux")
		nvimux.setup({
			config = {
				prefix = "<m-a>",
			},
			bindings = {
				{ { "n", "v", "i", "t" }, "s", nvimux.commands.horizontal_split },
				{ { "n", "v", "i", "t" }, "v", nvimux.commands.vertical_split },
			},
		})
	end,
}
