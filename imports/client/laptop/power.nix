{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.myScripts) pwr-manage auto-profile;
  batCapPath = "/home/cch/.config/batcap";
in {
  imports = [
    inputs.power-cap-rs.nixosModules.pwr-cap-rs
  ];

  environment.systemPackages = let
    batcap = pkgs.writeShellApplication {
      name = "batcap";
      text = ''
        path=${batCapPath}
        var=''${1-default}
        if [ "$var" == default ]; then
          cat "$path"
        elif [ "$var" == full ]; then
          echo 100 > "$path"
        elif [ "$var" == limit ]; then
          echo 80 > "$path"
        else
          echo "$var" > "$path"
        fi
      '';
    };
  in [batcap];

  systemd = {
    paths.batcap = {
      pathConfig = {
        PathChanged = batCapPath;
      };
      wantedBy = ["multi-user.target"];
    };

    services = {
      batcap = let
        batcap = pkgs.writeShellApplication {
          name = "batcap";
          text = ''
            percentage=$(cat ${batCapPath})
            echo "$percentage" | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
          '';
        };
      in {
        description = "set maximum battery percentage";

        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = getExe batcap;
        };

        wantedBy = ["multi-user.target"];
      };

      auto-profile = {
        description = "auto power profile selection";
        serviceConfig = {
          Type = "simple";
          User = "root";
          Restart = "always";
          ExecStart = getExe auto-profile;
        };

        after = [
          "power-profiles-daemon.service"
          "supergfxd.service"
        ];

        wantedBy = ["default.target"];
      };

      pwr-manage = {
        description = "power tweaks when unplugged";

        serviceConfig = {
          Type = "oneshot";
          User = "root";
          ExecStart = getExe pwr-manage;
        };

        after = ["power-profiles-daemon.service"];
      };
    };
  };

  services = {
    pwr-cap-rs = let
      limit = 7000;
    in {
      enable = true;
      tctl_limit = 85;
      quiet = {
        unplugged = {
          enable = true;
          stapm_limit = limit;
          fast_limit = limit;
          slow_limit = limit;
          apu_slow_limit = 20000;
        };
        plugged.enable = false;
      };
      balanced = {
        unplugged.enable = false;
        plugged.enable = false;
      };
      performance = {
        unplugged.enable = false;
        plugged.enable = false;
      };
    };

    supergfxd.enable = true;
    switcherooControl.enable = true;
    power-profiles-daemon = {
      enable = true;
    };
    udev.extraRules = let
      command = "${lib.getExe' pkgs.systemd "systemctl"} start pwr-manage.service";
      unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${command}"'';
      plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${command}"'';
    in
      lib.strings.concatLines [unplug plug];
  };
}
