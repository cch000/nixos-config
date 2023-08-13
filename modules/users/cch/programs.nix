{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    htop
    neofetch
    powerline-fonts
    terminator
    neovim
    yarn
    nodejs
    nil
    deadnix
    statix
    evince
    wl-clipboard
    tree
    gnome.eog
    gnome3.gnome-tweaks
    gnome.nautilus
    gimp
    tor-browser-bundle-bin
    fragments
    celluloid
  ];
}
