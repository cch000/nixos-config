{ pkgs
, ...
}: {
  services.flatpak.enable = true;

  #Buggy cursor fix

  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = with pkgs;[
          gnome.adwaita-icon-theme

          (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

        ];
        pathsToLink = [ "/share/fonts" "/share/icons" ];
      };
    in
    {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    };

  # system.fsPackages = [ pkgs.bindfs ];
  # fileSystems =
  #   let
  #     mkRoSymBind = path: {
  #       device = path;
  #       fsType = "fuse.bindfs";
  #       options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  #     };
  #     aggregatedFonts = pkgs.buildEnv {
  #       name = "system-fonts";
  #       paths = config.fonts.packages;
  #       pathsToLink = [ "/share/fonts" ];
  #     };
  #   in
  #   {
  #     # Create an FHS mount to support flatpak host icons/fonts
  #     "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
  #     "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  #   };



  # fileSystems =
  #   let
  #     mkRoSymBind = path: {
  #       device = path;
  #       options = [ "bind" ];
  #       depends = [ path ];
  #     };
  #     aggregatedFonts = pkgs.buildEnv {
  #       name = "system-fonts";
  #       paths = config.fonts.fonts;
  #       pathsToLink = [ "/share/fonts" ];
  #     };
  #   in
  #   {
  #     # Create an FHS mount to support flatpak host icons/fonts
  #     "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
  #     "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");

  #   };

}
