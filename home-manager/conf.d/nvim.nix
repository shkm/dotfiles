{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ./nvim/init.vim;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-commentary
      vim-unimpaired
      vim-rsi
      vim-fugitive
      matchit-zip
      splitjoin-vim
      vim-nix
      {
        plugin = vim-polyglot;
        config = ''
          autocmd FileType json5 setlocal commentstring=//\ %s
          let g:vim_markdown_folding_disabled = 1
        '';
      }
      {
        plugin = dracula-vim;
        config = "colorscheme dracula";
      }
      {
        plugin = lualine-nvim;
        config = ''
          lua << END
          require('lualine').setup {
            options = {
              theme = 'dracula'
            }
          }
          END
        '';
      }
      nvim-treesitter
      telescope-nvim
      nvim-web-devicons
      {
        plugin = lir-nvim;
        config = ''
          lua << END
            ${lib.fileContents ./nvim/lir.lua}
          END
        '';
      }
    ];
  };
}
