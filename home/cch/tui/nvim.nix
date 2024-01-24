{
  pkgs,
  inputs,
  ...
}: let
  vim-eva01 = pkgs.vimUtils.buildVimPlugin {
    name = "eva01.vim";
    src = inputs.vim-eva01;
  };

  vim-img-paste = pkgs.vimUtils.buildVimPlugin {
    name = "img-paste.vim";
    src = inputs.vim-img-paste;
  };
in {
  home.packages = with pkgs; [nil alejandra];

  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-eva01;
        config = "colorscheme eva01";
      }
      {
        plugin = vim-img-paste;
        config = "nmap <buffer><silent> <S-q> :call mdip#MarkdownClipboardImage()<CR>";
      }
      {
        plugin = coc-nvim;
        config = ''
          nmap <S-d> :CocCommand editor.action.formatDocument<CR>
          inoremap <silent><expr> <A-k> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
        '';
      }
      coc-json
      coc-clangd
      vim-lastplace
      vim-pandoc
      vim-pandoc-syntax
    ];

    extraConfig = ''
      "Basic preferences
      set encoding=utf-8
      set number relativenumber
      set fileformat=unix
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set cursorline
      set scrolloff=999
      set spelllang=en_us
      set colorcolumn=80
      set termguicolors

      "Close folds
      nmap <S-f> :foldclose<CR>
    '';

    coc = {
      enable = true;
      settings = {
        languageserver = {
          # Nix setup
          nix = {
            # The command to run
            command = "nil";
            settings = {
              nil = {
                formatting = {
                  command = ["alejandra"];
                };
                nix = {
                  flake = {
                    autoArchive = true;
                    autoEvalInputs = false;
                    nixpkgsInputName = "nixpkgs";
                  };
                };
              };
            };
            # Run on nix files.
            filetypes = [
              "nix"
            ];
          };
        };
      };
    };
  };
}
