{pkgs, ...}: {
  home.packages = with pkgs; [
    #terminal stuff
    htop
    neofetch
    powerline-fonts
    wl-clipboard
    tree
    killall

    #gui
    evince
    gnome.eog
    gnome3.gnome-tweaks
    gnome.nautilus
    gnome.gnome-calendar
    gimp
    tor-browser-bundle-bin
    fragments
    celluloid
  ];

  programs.obs-studio.enable = true;
}
