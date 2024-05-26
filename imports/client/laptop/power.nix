{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) getExe;
  inherit (config.myScripts) pwr-manage;
  batCapPath = "/home/cch/.config/bat-cap";
in {
  imports = [
    inputs.power-cap-rs.nixosModules.pwr-cap-rs
  ];

  environment.systemPackages = let
    bat-cap = pkgs.writeShellApplication {
      name = "bat-cap";
      text = ''
        path=${batCapPath}
        var=''${1-default}
        if [ "$var" == default ]; then
          cat "$path"
        else
          echo "$var" > "$path"
        fi
      '';
    };
  in [bat-cap];

  systemd = {
    paths.bat-cap = {
      pathConfig = {
        PathChanged = batCapPath;
      };
      wantedBy = ["multi-user.target"];
    };

    services = {
      bat-cap = let
        bat-cap = pkgs.writeShellApplication {
          name = "bat-cap";
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
          ExecStart = getExe bat-cap;
        };

        wantedBy = ["multi-user.target"];
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
    pwr-cap-rs = {
      enable = true;
      stapm-limit = 7000;
      fast-limit = 7000;
      slow-limit = 7000;
      onlyOnBattery = true;
    };

    supergfxd.enable = true;
    switcherooControl.enable = true;
    power-profiles-daemon.enable = true;
    udev.extraRules = let
      command = "${lib.getExe' pkgs.systemd "systemctl"} start pwr-manage.service";
      unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${command}"'';
      plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${command}"'';
    in
      lib.strings.concatLines [unplug plug];
  };

  powerManagement.cpuFreqGovernor = "conservative";
}
