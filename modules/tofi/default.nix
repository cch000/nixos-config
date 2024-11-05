{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.rice-services;
in {
  config = mkIf cfg.enable {
    home-manager.users.${username}.programs.tofi = {
      enable = true;
      package = pkgs.tofi.overrideAttrs (_: {
        # https://github.com/philj56/tofi/issues/165
        patches = [
          ./tofi.patch
        ];
      });
      settings = {
        width = 500;
        height = 300;
        horizontal = false;
        prompt-text = "> ";
        font-size = 16;
        font = "${(pkgs.nerdfonts.override {
            fonts = ["JetBrainsMono"];
          })
          .outPath}/share/fonts/truetype/NerdFonts/JetBrainsMonoNLNerdFontMono-Bold.ttf";
        ascii-input = false;
        outline-width = 2;
        outline-color = "#ff7800";
        border-width = 0;
        background-color = "#000000";
        text-color = "#ff7800";
        selection-color = "#00b817";
        min-input-width = 120;
        result-spacing = 10;
        padding-top = 15;
        padding-bottom = 15;
        padding-left = 15;
        padding-right = 15;
      };
    };
  };
}
