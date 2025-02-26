return {
    "rebelot/kanagawa.nvim",
    branch="master",
    config=function()
        require('kanagawa').setup({
            transparent=true,
        });
        vim.cmd("colorscheme kanagawa");
    end,
}
