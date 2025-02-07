return {
	"rebelot/kanagawa.nvim",
	config=function() 
		require('kanagawa').setup({
			compile=true,
			transparent=true,
		});
		vim.cmd("colorscheme kanagawa");
	end,
	build = function()
		vim.cmd("KanagawaCompile");
	end,
}
