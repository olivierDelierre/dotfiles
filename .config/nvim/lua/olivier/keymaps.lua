local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Plugins -- 
-- fzf.vim
keymap("n", "<leader>f", ":FzfLua files<CR>", opts)
keymap("n", "<leader>g", ":FzfLua live-grep<CR>", opts)

-- NORMAL Mode --
-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>e", ":Lex 30<cr>", opts) -- Leader + E open the explorer
keymap("n", "<leader>o", "o<Esc>", opts)

-- Move text
keymap("n", "<A-j>", "V :m .+1<CR>==", opts)
keymap("n", "<A-k>", "V :m .-2<CR>==", opts)

-- Resize
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- INSERT Mode --
keymap("i", "jk", "<Esc>", opts)

-- VISUAL Mode --
-- Indents
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

