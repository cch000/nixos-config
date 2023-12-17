_: {
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar.css;
    settings = {
      mainBar = {
        width = 40;
        layer = "top";
        position = "left";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["tray" "wireplumber" "network" "battery" "custom/power"];

        "hyprland/workspaces" = {
          format = "";
        };

        "clock" = {
          format = "{:%H\n%M}";
        };

        "wireplumber" = {
          format = "{icon}";
          format-muted = "󰝟";
          format-icons = ["" "" ""];
        };

        "network" = {
          format-wifi = "{icon}";
          format-ethernet = " ";
          format-linked = "";
          format-disconnected = ":(";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];

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
        };

        "custom/power" = {
          format = "⭘";
          on-click = "shutdown now";
        };
      };
    };
  };
}
