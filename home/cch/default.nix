{...}: {
  home.username = "cch";

  home.stateVersion = "23.05"; #Do not change this

  programs.home-manager.enable = true;

  imports = [
    ./tui
    ./cli
    ./gui
    ./other
    ./services
    ./wayland
  ];
}
