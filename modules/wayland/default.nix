{pkgs, ...}: {
  imports = [
    ./pipewire.nix
    ./hyprland.nix
    ./login.nix
  ];

  programs.dconf.enable = true;

  hardware.opengl.enable = true;

  #fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
}
