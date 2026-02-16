return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
		float = {
			-- add padding to floating window. More padding = smaller window.
			padding = 10,
			-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			max_width = 0.50,
			max_height = 0,
			-- border around the window: "nil", "single" "double" etc.
			border = "single", -- at least single needed for displaying path on top of floating window.
			win_options = {
				winblend = 25, -- Make window opaque -> 0 or translucent -> any number. Higher = more translucent
			},
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
