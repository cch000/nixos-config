{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "es";
      xkbVariant = "";
      excludePackages = [pkgs.xterm];
    };
    gnome.core-utilities.enable = false; #Minimal gnome install
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];
}
