{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        enkia.tokyo-night
        vscodevim.vim
        valentjn.vscode-ltex
        redhat.java
        matklad.rust-analyzer
        llvm-vs-code-extensions.vscode-clangd
        mkhl.direnv
        ms-vscode.cmake-tools
        ms-dotnettools.csharp
        gitlab.gitlab-workflow
        redhat.vscode-yaml
        timonwong.shellcheck
        foxundermoon.shell-format
        james-yu.latex-workshop
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vsliveshare";
          publisher = "ms-vsliveshare";
          version = "1.0.5892";
          sha256 = "0c4xvs96ccih47l76r6l5bkjfhgiair90yy8syibdq3zshw0kxvv";
        }
      ];

    userSettings = {
      workbench.colorTheme = "Tokyo Night Storm";
      files.autoSave = "afterDelay";
      window = {
        menuBarVisibility = "toggle";
        titleBarStyle = "custom";
      };

      redhat.telemetry.enabled = false;

      editor = {
        minimap.enabled = false;
        fontFamily = "JetBrainsMono Nerd Font";
        fontLigatures = true;
        cursorSurroundingLines = 999;
      };

      terminal = {
        integrated.fontFamily = "JetBrainsMono Nerd Font Mono";
      };

      extensions.ignoreRecommendations = true;

      clangd.path = "${pkgs.clang-tools}/bin/clangd";

      nix = {
        enableLanguageServer = true;
        serverPath = "nil";
        serverSettings = {
          nil = {
            formatting = {
              command = ["alejandra"];
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

      vim.normalModeKeyBindings = [
        {
          before = ["<S-d>"];
          commands = [
            "editor.action.formatDocument"
          ];
        }
      ];

      telemetry.telemetryLevel = "off";
    };
  };
}
