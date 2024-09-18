local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer, close and reopen nvim..."
  vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Plugins definition
return packer.startup(function(use)
  -- Plugins
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use {
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = ':call fzf#install()' }
  }

  -- Color schemes
  use "lunarvim/colorschemes"
  use "folke/tokyonight.nvim"

  -- CMP (completion)
  use 'hrsh7th/nvim-cmp' -- Completion plugin itself
  use 'hrsh7th/cmp-buffer' -- Buffer
  use 'hrsh7th/cmp-path' -- Path
  use 'hrsh7th/cmp-cmdline' -- Command lines
  use 'saadparwaiz1/cmp_luasnip' -- Snippets

  -- Snippets
  use 'L3MON4D3/LuaSnip' -- Snippet engine
  use 'rafamadriz/friendly-snippets' -- A bunch of snippets

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
