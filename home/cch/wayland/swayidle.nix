# taken from https://github.com/fufexan/dotfiles/blob/main/home/services/swayidle.nix
{
  lib,
  pkgs,
  ...
}: let
  suspendScript = pkgs.writeScript "suspend-script" ''
    #!/usr/bin/env bash

    pwr_supply=$(echo /sys/class/power_supply/A*)
    connected="$pwr_supply/online"

    if [[ $(cat "$connected") == "0" ]]; then

      # only suspend if audio isn't running
      ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
      if [[ $? == 1 ]]; then
        ${pkgs.systemd}/bin/systemctl suspend
      fi
    fi
  '';
in {
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  # screen idle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 330;
        command = suspendScript.outPath;
      }
    ];
  };
}
