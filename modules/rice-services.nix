{
  username,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.myOptions.rice-services;
in {
  options.myOptions.rice-services = {
    enable = mkEnableOption "some necessary services and configurations for wms";
  };
  config = mkIf cfg.enable {
    ### Nixos stuff ###
    # unlock GPG keyring on login
    programs.gnupg.agent.enable = true;
    services.gvfs.enable = true; # so that external devices to show up on nautilus
    security.polkit.enable = true;
    programs.dconf.enable = true;
    hardware.opengl.enable = true;

    security.pam.services = {
      #Allow swaylock to unlock the screen
      swaylock.text = "auth include login";
      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
    };

    systemd = {
      user.services.polkit-pantheon-authentication-agent-1 = {
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          };
        };
      };

      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };
      logind = {
        lidSwitch = "suspend";
        lidSwitchExternalPower = "lock";
        extraConfig = ''
          HandlePowerKey=suspend
        '';
      };
    };

    #fonts
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];

    ### home-manager stuff ###
    home-manager.users.${username} = {
      ### swaylock ###
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

      services = {
        ### dunst ###
        dunst = {
          enable = true;
          settings = {
            global = {
              notification_limit = 3;
              frame_color = "#ff7800";
              highlight = "#ff7800";
              corner_radius = 10;
              background = "#000000";
              foreground = "#ff7800";
              font = "JetBrains Mono 12";
            };
          };
        };
        ### wlsunset ###
        wlsunset = {
          enable = true;
          latitude = "57.7";
          longitude = "11.9";
        };
        ### swayidle ###
        swayidle = let
          suspendScript = pkgs.writeScript "suspend-script" ''

            #!/usr/bin/env bash

            export PATH=$PATH:${dependencies}

            pwr_supply=$(echo /sys/class/power_supply/A*)
            connected="$pwr_supply/online"

            # only do something if audio isn't running
            pw-cli i all | rg running
            if [[ $? == 1 ]]; then

              if [[ $(cat "$connected") == "0" ]]; then
                systemctl suspend
              else
                swaylock
                sleep 2
                hyprctl dispatch dpms off
              fi
            fi
          '';
          dependencies = with pkgs;
            lib.makeBinPath [
              ripgrep
              coreutils
              pipewire
              swaylock-effects
              hyprland
              systemd
            ];
        in {
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
      };
    };
  };
}
