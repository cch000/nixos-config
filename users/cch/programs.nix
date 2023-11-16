{pkgs, ...}: {
  home.packages = with pkgs; [
    #terminal stuff
    htop
    neofetch
    powerline-fonts
    terminator
    wl-clipboard
    tree

    #dev
    neovim
    yarn
    nodejs
    nil
    deadnix
    statix
    alejandra

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