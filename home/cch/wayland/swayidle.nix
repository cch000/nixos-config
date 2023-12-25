# inspired by https://github.com/fufexan/dotfiles/blob/c16e7e2e2c19cd2f5be044b2b3548b5a19348a65/home/services/swayidle.nix
{
  pkgs,
  lib,
  ...
}: let
  suspendScript = pkgs.writeScript "suspend-script" ''

    #!/usr/bin/env bash

    export PATH=$PATH:${dependencies}

    pwr_supply=$(echo /sys/class/power_supply/A*)
    connected="$pwr_supply/online"

    if [[ $(cat "$connected") == "0" ]]; then

      # only suspend if audio isn't running
      pw-cli i all | rg running
      if [[ $? == 1 ]]; then
        systemctl suspend
      fi

    else

      swaylock
      sleep 2
      hyprctl dispatch dpms off

    fi
  '';
  dependencies = with pkgs;
    lib.makeBinPath [
      ripgrep
      coreutils
      pipewire
      swaylock-effects
      hyprland
    ];
in {
  # screen idle
  services.swayidle = {
    systemdTarget = "hyprland-session.target";
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
        timeout = 300;
        command = suspendScript.outPath;
      }
    ];
  };
}
