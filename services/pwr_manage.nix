{
  config,
  pkgs,
  ...
}: {
  
  systemd.services.pwr_manage = {
    enable = true;
    serviceConfig = {
      Restart = "always";
      RestartSec = "10";
    };

    script = ''
      #!/usr/bin/env bash

      bat=$(echo /sys/class/power_supply/BAT*)
      bat_status="$bat/status"

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

    '';
    wantedBy = ["default.target"];
  };
}
