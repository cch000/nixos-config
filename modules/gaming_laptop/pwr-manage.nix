{pkgs, ...}: {
  systemd.services.pwr-manage = let
    pwr-manage = pkgs.writeScript "pwr-manage" ''

      #!/usr/bin/env bash

      readonly min_version=6.3
      current_version=$(uname -r | cut -c1-3)

      pwr_supply=$(echo /sys/class/power_supply/A*)
      connected="$pwr_supply/online"

      bat=$(echo /sys/class/power_supply/BAT*)
      bat_status="$bat/status"

      prev=0

      while true; do

        #check if the laptop is plugged
        if [[ $(cat "$connected") == "0" ]]; then

          "${pkgs.power-profiles-daemon}"/bin/powerprofilesctl set power-saver

          driver="passive"
          governor="conservative"

        else

          driver="active"
          governor="performance"

        fi

        if [[ "$prev" != "$governor" ]]; then

          if (( $(echo "$current_version >= $min_version" |"${pkgs.bc}"/bin/bc -l ))); then
            echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status
          fi

          for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
            echo "$governor" | tee "$i" > /dev/null
          done

        fi

        prev=$governor

        #wait for the next power change event
        "${pkgs.inotify-tools}"/bin/inotifywait -qq "$bat_status"

      done

    '';
  in {
    enable = true;
    script = "${pwr-manage}";
    after = ["cpufreq.service"];
    wantedBy = ["default.target"];
  };
}
