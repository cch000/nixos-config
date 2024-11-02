{
  pkgs,
  lib,
  username,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.vscodium;
in {
  options.myOptions.vscodium = {
    enable = mkEnableOption "vscodium";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions;
        [
          twxs.cmake
          jnoortheen.nix-ide
          vscodevim.vim
          jdinhlife.gruvbox
          valentjn.vscode-ltex
          redhat.java
          vscjava.vscode-java-test
          vscjava.vscode-maven
          vscjava.vscode-java-debug
          rust-lang.rust-analyzer
          llvm-vs-code-extensions.vscode-clangd
          mkhl.direnv
          ms-vscode.cmake-tools
          ms-dotnettools.csharp
          gitlab.gitlab-workflow
          redhat.vscode-yaml
          timonwong.shellcheck
          foxundermoon.shell-format
          james-yu.latex-workshop
          vadimcn.vscode-lldb
          ms-python.python
          ms-python.vscode-pylance
          ms-python.black-formatter
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vsliveshare";
            publisher = "ms-vsliveshare";
            version = "1.0.5892";
            sha256 = "0c4xvs96ccih47l76r6l5bkjfhgiair90yy8syibdq3zshw0kxvv";
          }
          # requires microsoft c/c++ extension :(
          #{
          #  name = "vscode-arduino";
          #  publisher = "vsciot-vscode";
          #  version = "0.2.29";
          #  sha256 = "0q727mgncrcjlrag6aaa95h65sa7x7z23c8cxnjcpmkgfb2gcmin";
          #}
        ];

      userSettings = {
        workbench.colorTheme = "Gruvbox Dark Hard";
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
          fontSize = 14;
          cursorSurroundingLines = 999;
        };

        terminal.integrated = {
          fontFamily = "JetBrainsMono Nerd Font Mono";
          fontSize = 14;
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

        ltex = {
          additionalRules.motherTongue = "es";
          language = "en-GB";
          additionalRules.enablePickyRules = true;
        };
        latex-workshop = {
          latex = {
            recipe.default = "latexmk (lualatex)";
            autoBuild.run = "never";
          };

          message.error.show = false;
          message.warning.show = false;
        };
      };
    };
  };
}
