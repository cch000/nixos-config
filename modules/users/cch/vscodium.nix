{ pkgs
, ...
}: {

  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    gcc
    jdk
    nixpkgs-fmt
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      vscodevim.vim
      valentjn.vscode-ltex
      redhat.java
      jdinhlife.gruvbox
      matklad.rust-analyzer
    ];

    userSettings = {
      workbench.colorTheme = "Gruvbox Dark Medium";
      files.autoSave = "afterDelay";
      window.menuBarVisibility = "toggle";

      editor = {
        minimap.enabled = false;
        fontFamily = "JetBrainsMono Nerd Font";
        fontLigatures = true;
      };

      nix = {
        enableLanguageServer = true;
        serverPath = "nil";
        serverSettings = {
          nil = {
            formatting = {
              command = [ "nixpkgs-fmt" ];
            };
          };
        };
      };

      java = {
        configuration.runtimes = [
          {
            name = "JavaSE-19";
            path = "${pkgs.jdk}/lib/openjdk";
            default = true;
          }
        ];
        jdt.ls.java.home = "${pkgs.jdk}/lib/openjdk";
      };
    };
  };
}
