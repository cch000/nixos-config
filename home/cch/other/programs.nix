{pkgs, ...}: {
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
    pavucontrol
    webcord-vencord
    spotify
    vorta
  ];

  programs.obs-studio.enable = true;
}
