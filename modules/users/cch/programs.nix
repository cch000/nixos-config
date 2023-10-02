{pkgs, ...}: {
  home.packages = with pkgs; [
    #terminal stuff
    htop
    neofetch
    powerline-fonts
    terminator
    wl-clipboard
    tree
    direnv

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
    gimp
    tor-browser-bundle-bin
    fragments
    celluloid
  ];
}
