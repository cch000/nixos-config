{
  pkgs,
  lib,
  ...
}: let
  pwrprofilecycle = pkgs.writeShellApplication {
    name = "pwrprofilecycle";
    text = builtins.readFile ./pwrprofilecycle.sh;
    runtimeInputs = ["powerprofilesctl" "sleep"];
  };
in {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        width = 40;
        layer = "top";
        position = "left";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["custom/pwrprofiles" "backlight" "wireplumber" "network" "battery" "custom/power"];

        "hyprland/workspaces" = {
          format = "";
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
        };

        "custom/pwrprofiles" = {
          exec = "${lib.getBin pwrprofilecycle}/bin/pwrprofilecycle -m";
          interval = 60;
          on-click = "${lib.getBin pwrprofilecycle}/bin/pwrprofilecycle";
          exec-on-event = true;
          tooltip = false;
        };

        "network" = {
          format-wifi = "{icon}";
          format-ethernet = "";
          format-linked = "";
          format-disconnected = "0";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format = "{essid} {signalStrength}%";

          on-click = "terminator -e nmtui";
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
