{...}: {
  home.username = "cch";

  home.stateVersion = "23.05"; #Do not change this

  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./programs.nix
    ./gtk.nix
    ./vscodium.nix
    ./gnome.nix
    ./xdg.nix
    ./shell.nix
    ./nvim.nix
    ./rice
  ];
}
