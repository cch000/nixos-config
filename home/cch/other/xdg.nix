{config, ...}: let
  associations = {
    "application/pdf" = ["org.gnome.Evince.desktop"];
    "inode/directory" = ["org.gnome.Nautilus.desktop"];
  };
in {
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;

      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
