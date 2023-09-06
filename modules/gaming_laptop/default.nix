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

  powerManagement.cpuFreqGovernor = "conservative";

  environment.systemPackages = with pkgs; [ inotify-tools ryzenadj ];

  systemd.services.pwr-manage =
    let
      pwr-manage = pkgs.writeScript "pwr-manage" ''

      #!/usr/bin/env bash

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

        if [[ $prev != "$governor" ]]; then

          echo "$driver" | tee /sys/devices/system/cpu/amd_pstate/status

          for i in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
            echo "$governor" | tee "$i" > /dev/null
          done

        fi

        prev=$governor

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

  systemd.services.ryzenadj =
    let
      ryzenadj = pkgs.writeScript "ryzenadj" ''

      #!/usr/bin/env bash
      
      prev=0
      
      while true; do
      
        pwr_profile=$("${pkgs.power-profiles-daemon}"/bin/powerprofilesctl get)
      
        if [[ "$pwr_profile" == "power-saver" ]]; then
      
          sus_pl=7000                              # Sustained Power Limit (mW)
          actual_pl=7000                           # ACTUAL Power Limit    (mW)
          avg_pl=7000                              # Average Power Limit   (mW)
          vrm_edc=90000                            # VRM EDC Current       (mA)
          max_tmp=85                               # Max Tctl              (C)

          "${pkgs.ryzenadj}"/bin/ryzenadj -a $sus_pl -b $actual_pl -c $avg_pl -k $vrm_edc -f $max_tmp > /dev/null
      
        elif [[ "$pwr_profile" != "$prev" ]]; then
        
          "${pkgs.power-profiles-daemon}"/bin/powerprofilesctl set "$pwr_profile"
        
        fi
        
        prev=$pwr_profile
        
        sleep 10
      
      done

    '';
    in
    {
      enable = true;
      script = "${ryzenadj}";
      wantedBy = [ "default.target" ];
    };
}
