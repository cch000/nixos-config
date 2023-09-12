{ pkgs
, ...
}: {

  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    gcc
    jdk
    llvmPackages_rocm.clang-tools-extra
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
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
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      octref.vetur
    ];

    userSettings = {
      workbench.colorTheme = "Gruvbox Dark Medium";
      files.autoSave = "afterDelay";
      window.menuBarVisibility = "toggle";

      redhat.telemetry.enabled = false;

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

      vim.normalModeKeyBindings = [{

        before = [ "<S-d>" ];
        commands = [
          "editor.action.formatDocument"
        ];
      }];

      telemetry.telemetryLevel = "off";
    };
  };
}
