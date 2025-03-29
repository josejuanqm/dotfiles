local map = vim.api.nvim_set_keymap

map('n', '<leader>bb', '<cmd>:XcodebuildBuild<CR>', { silent = true });
map('n', '<leader>br', '<cmd>:XcodebuildBuildRun<CR>', { silent = true });
