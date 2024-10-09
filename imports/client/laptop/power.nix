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
    pwr-cap-rs = {
      enable = true;
      stapm-limit = 7000;
      fast-limit = 7000;
      slow-limit = 7000;
      onlyOnBattery = true;
    };

    supergfxd.enable = true;
    switcherooControl.enable = true;
    power-profiles-daemon = {
      enable = true;
      #package = pkgs.power-profiles-daemon.overrideAttrs (
      #  _: let
      #    version = "0.20";
      #  in {
      #    inherit version;
      #    src = pkgs.fetchFromGitLab {
      #      domain = "gitlab.freedesktop.org";
      #      owner = "upower";
      #      repo = "power-profiles-daemon";
      #      rev = version;
      #      sha256 = "sha256-8wSRPR/1ELcsZ9K3LvSNlPcJvxRhb/LRjTIxKtdQlCA=";
      #    };

      #    mesonFlags = [
      #      "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
      #      "-Dgtk_doc=true"
      #      "-Dpylint=false"
      #    ];
      #  }
      #);
    };
    udev.extraRules = let
      command = "${lib.getExe' pkgs.systemd "systemctl"} start pwr-manage.service";
      unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${command}"'';
      plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${command}"'';
    in
      lib.strings.concatLines [unplug plug];
  };

  powerManagement.cpuFreqGovernor = "conservative";
}
