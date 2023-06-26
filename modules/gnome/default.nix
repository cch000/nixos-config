{
  config,
  pkgs,
  ...
}: {
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

  hardware.opengl.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  programs.dconf.enable = true;

  #fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
}
