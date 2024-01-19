{
  pkgs,
  lib,
  inputs,
  ...
}: let
  pwrprofilecycle = pkgs.writeShellApplication {
    name = "pwrprofilecycle";
    text = builtins.readFile ./pwrprofilecycle.sh;
    runtimeInputs = with pkgs; [power-profiles-daemon coreutils];
  };
in {
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.x86_64-linux.default;
    systemd.enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        width = 40;
        layer = "top";
        position = "left";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["bluetooth" "custom/pwrprofiles" "backlight" "wireplumber" "network" "battery" "custom/power"];

        "hyprland/workspaces" = {
          active-only = false;
          format = "";
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "backlight" = {
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
          tooltip = false;
        };

        "clock" = {
          format = "{:%H\n%M}";
        };

        "wireplumber" = {
          format = "{icon}";
          format-muted = "󰝟";
          format-icons = ["" "" ""];
          tooltip-format = "{node_name} {volume}%";
        };

        "bluetooth" = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          tooltip-format = "{device_alias}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          on-click = "blueman-manager";
        };

        "custom/pwrprofiles" = {
          exec = "${lib.getExe pwrprofilecycle}";
          on-click = "${pkgs.asusctl}/bin/asusctl profile -n; ${pkgs.busybox}/bin/pkill -SIGRTMIN+8 waybar";
          tooltip = false;
          signal = 8;
        };

        "network" = {
          format-wifi = "{icon}";
          format-ethernet = "";
          format-linked = "";
          format-disconnected = "0";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format = "{essid} {signalStrength}%";
        };

        "battery" = {
          states = {
            warning = 40;
            critical = 20;
          };
          format = "{icon}";
          format-plugged = "";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{capacity}% {timeTo}";
        };

        "custom/power" = {
          format = "⭘";
          on-click = "shutdown now";
        };
      };
    };
  };
}
