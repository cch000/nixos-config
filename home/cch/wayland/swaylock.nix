{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = rec {
      daemonize = true;
      clock = true;
      font = "JetBrainsMono Nerd Font";
      indicator = true;
      color = "000000";
      text-color = "ff7800";
      key-hl-color = "6A329F";
      ring-color = "${text-color}";
      inside-color = "${color}";
      ring-ver-color = "${text-color}";
      inside-ver-color = "${text-color}";
    };
  };
}
