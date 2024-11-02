{
  pkgs,
  lib,
  config,
  username,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.myScripts) btdu-helper;
  inherit (inputs.merged-yet.packages.${pkgs.system}) merged-yet;
  cfg = config.myOptions.defaultPrograms;
in {
  options.myOptions.defaultPrograms = {
    enable = mkEnableOption "default programs";
  };
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      silent = true;
      # faster, permanent implementation of use_nix and use_flake
      nix-direnv.enable = true;
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        #terminal stuff
        htop
        neofetch
        powerline-fonts
        wl-clipboard
        tree
        killall
        zip
        unzip
        btdu-helper
        merged-yet
        typioca
        mpv

        #gui
        papers
        eog
        nautilus
        gnome-calendar
        gimp
        tor-browser-bundle-bin
        fragments
        celluloid
        pavucontrol
        webcord-vencord
        spotify
        vorta
        mgba
        zed-editor
        freetube
        bitwarden
      ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs #For screen capture in Hyprland
        ];
      };
    };
  };
}
