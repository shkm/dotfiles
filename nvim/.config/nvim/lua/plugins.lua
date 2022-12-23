return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-rsi'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rails'
  use 'janko-m/vim-test'
  use 'vim-scripts/matchit.zip'
  use 'AndrewRadev/splitjoin.vim'
  use 'pangloss/vim-javascript'
  use 'elzr/vim-json'
  use 'vim-scripts/txt.vim'
  use 'vim-scripts/yaml.vim'
  use 'rafcamlet/nvim-luapad'
  use 'AndrewRadev/sideways.vim'
  --use 'tommcdo/vim-indent-object'
  use 'rust-lang/rust.vim'
  use 'kyazdani42/nvim-web-devicons'
  use 'dhruvasagar/vim-table-mode'
  use 'vim-crystal/vim-crystal'

  vim.api.nvim_set_var('vim_markdown_folding_disabled', 1)
  vim.api.nvim_set_var('vim_markdown_new_list_item_indent', 0)
  use {
    'plasticboy/vim-markdown'
  }

  use {
    'tanvirtin/monokai.nvim',
    config = function()
      require('monokai').setup { }
      vim.colorscheme = 'monokai'
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('lualine').setup {
        options = {
          theme = 'molokai'
        }
      }
    end
  }


  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim', {'kyazdani42/nvim-web-devicons', opt = true} },
    config = function()
      require('plugins/telescope')
    end
  }

  use {
    'tamago324/lir.nvim',
    config = function()
      require('plugins/lir')
    end
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim', {'kyazdani42/nvim-web-devicons', opt = true} },
    config = function()
      require('gitsigns').setup()
    end
  }

use {
     'ms-jpq/coq_nvim',
     branch = 'coq',
     event = "VimEnter",
     config = 'vim.cmd[[COQnow]]'
}
use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
end)

