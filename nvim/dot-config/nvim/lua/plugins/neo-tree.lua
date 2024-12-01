return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  config = function()
    vim.keymap.set("n", "<leader>df", ":Neotree toggle filesystem float<CR>")
    vim.keymap.set("n", "<leader>db", ":Neotree toggle buffers float<CR>")
    vim.keymap.set("n", "<leader>dg", ":Neotree toggle git_status float<CR>")
  end
}

