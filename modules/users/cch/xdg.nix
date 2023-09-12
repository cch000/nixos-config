_: {
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
      "inode/directory" = ["org.gnome.Nautilus.desktop"];
    };
  };
}
