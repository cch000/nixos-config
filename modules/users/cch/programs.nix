{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    htop
    neofetch
    powerline-fonts
    terminator
    neovim
    yarn
    nodejs
    rnix-lsp
    evince
    wl-clipboard
    tree
    gnome.eog
    gnome3.gnome-tweaks
    gnome.nautilus
    gimp
  ];
}
