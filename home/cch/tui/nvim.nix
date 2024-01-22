{pkgs, ...}: {
  home.packages = with pkgs; [nil alejandra];

  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      vim-airline
      vim-airline-themes
      vim-devicons
      vim-pandoc
      vim-pandoc-syntax
      coc-nvim
      coc-json
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

      set background=dark

      colorscheme tokyonight-moon

      "Plugin preferences

      "Airline bar preferences
      let g:airline_theme='violet'
      let g:airline_powerline_fonts = 1

      "Paste img preferences
      nmap <buffer><silent> <S-q> :call mdip#MarkdownClipboardImage()<CR>

      "vim-pandoc preferences
      "let g:pandoc#modules#disabled = ['folding']

      "Save and export RMarkdown to pdf
      nmap <S-e> :w<CR>:RMarkdown pdf<CR>

      "Close folds
      nmap <S-f> :foldclose<CR>

      "Coc shorcuts
      nmap <S-d> :CocCommand editor.action.formatDocument<CR>
      inoremap <silent><expr> <A-k> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
    '';

    coc = {
      enable = true;
      settings = {
        # Nix setup.
        languageserver.nix = {
          # The command to run.
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
}
