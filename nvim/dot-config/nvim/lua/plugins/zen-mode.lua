return {
  "folke/zen-mode.nvim",
  config = function()
    vim.keymap.set("n", "<leader>zz", ":ZenMode<CR>")
  end
}
