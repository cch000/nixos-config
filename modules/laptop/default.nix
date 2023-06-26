{
  config,
  pkgs,
  ...
}: {
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  environment.systemPackages = [pkgs.inotify-tools];

  systemd.services.pwr-manage = let
    pwr-manage = pkgs.writeScript "pwr-manage" ''

      #!/usr/bin/env bash

      bat=$(echo /sys/class/power_supply/BAT*)
      bat_status="$bat/status"

      while true; do

        if [[ $(cat "$bat_status") == "Discharging" ]]; then

          echo "passive" | tee /sys/devices/system/cpu/amd_pstate/status

          for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
            echo "conservative" | tee "$i"
          done

        else

          echo "active" | tee /sys/devices/system/cpu/amd_pstate/status

          for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
            echo "performance" | tee "$i"
          done

        fi

        "${pkgs.inotify-tools}"/bin/inotifywait -qq "$bat_status"

      done

    '';
  in {
    enable = true;
    script = "${pwr-manage}";
    wantedBy = ["default.target"];
  };
}
