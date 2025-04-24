return {
    "jakobwesthoff/project-fzf.nvim",
    dependencies = {
        "ahmedkhalf/project.nvim", -- Must be configured separately
        "ibhagwan/fzf-lua",
    },
    opts = {}, -- Will call require('project-fzf').setup(opts)
}
