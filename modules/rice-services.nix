{
  username,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.myScripts) lock pwrprofilecycle;
  cfg = config.myOptions.rice-services;
in {
  # Note that other modules also depend on this option to be true
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
    hardware.graphics.enable = true;

    environment = {
      variables = {
        GDK_SCALE = "1.8";
      };
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = [
        pkgs.brightnessctl
        pwrprofilecycle
        lock
      ];
    };

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
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
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
            command = "${pkgs.greetd.greetd}/bin/agreety --cmd 'niri-session'";
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
          temperature.night = 3000;
          systemdTarget = "niri.target";
        };
        ### swayidle ###
        swayidle = {
          systemdTarget = "niri.target";
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.systemd}/bin/loginctl lock-session";
            }
            {
              event = "lock";
              command = "${lib.getExe lock}";
            }
          ];
          timeouts = let
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
                fi
              fi
            '';

            notifyScript = pkgs.writeScript "notify-script" ''
              #!/usr/bin/env bash

              export PATH=$PATH:${dependencies}

              connected=$(cat /sys/class/power_supply/A*/online)

              if [ $connected == "0" ]; then

                notify-send -t 18000 "ZZZZZZZZZZZ soon"

              fi
            '';

            dependencies = with pkgs;
              lib.makeBinPath [
                ripgrep
                coreutils
                pipewire
                systemd
                libnotify
              ];
          in [
            {
              timeout = 300;
              command = suspendScript.outPath;
            }
            {
              timeout = 285;
              command = notifyScript.outPath;
            }
          ];
        };
      };
    };
  };
}
