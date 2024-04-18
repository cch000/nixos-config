{
  config,
  username,
  ...
}: let
  associations = {
    "application/pdf" = ["org.gnome.Evince.desktop"];
    "inode/directory" = ["org.gnome.Nautilus.desktop"];
  };
in {
  home-manager.users.${username}.xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home-manager.users.${username}.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
