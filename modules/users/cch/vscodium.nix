{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    userSettings = {
      "workbench.colorTheme" = "Gruvbox Material Dark";
      "window.zoomLevel" = -1;
      "files.autoSave" = "afterDelay";
      "window.menuBarVisibility" = "toggle";
      "editor.minimap.enabled" = false;
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "editor.fontLigatures" = true;
    };
  };
}
