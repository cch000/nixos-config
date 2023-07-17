{ pkgs
, ...
}: {
  gtk = with pkgs; {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = papirus-icon-theme;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = adw-gtk3;
    };
  };
}
