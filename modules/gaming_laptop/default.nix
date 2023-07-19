{ pkgs
, ...
}: {
  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
    switcherooControl.enable = true;
  };

  environment.systemPackages = [ pkgs.inotify-tools ];

  systemd.services.pwr-manage =
    let
      pwr-manage = pkgs.writeScript "pwr-manage" ''

      #!/usr/bin/env bash

      pwr_supply=$(echo /sys/class/power_supply/A*)
      connected="$pwr_supply/online"

      bat=$(echo /sys/class/power_supply/BAT*)
      bat_status="$bat/status"

      while true; do

        #check if the laptop is plugged
        if [[ $(cat "$connected") == "0" ]]; then

          "${pkgs.power-profiles-daemon}"/bin/powerprofilesctl set power-saver

          driver="passive"
          profile="schedutil"

        else

          driver="active"
          profile="performance"

        fi


        echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status > /dev/null

        for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
          echo "$profile" | tee "$i" > /dev/null
        done

        #wait for the next power change event
       "${pkgs.inotify-tools}"/bin/inotifywait -qq "$bat_status"

      done

    '';
    in
    {
      enable = true;
      script = "${pwr-manage}";
      wantedBy = [ "default.target" ];
    };
}
