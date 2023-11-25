{pkgs, ...}: {
  systemd.services.ryzenadj = let
    ryzenadj = pkgs.writeScript "ryzenadj" ''

      #!/usr/bin/env bash

      prev=0

      while true; do

        pwr_profile=$("${pkgs.power-profiles-daemon}"/bin/powerprofilesctl get)

        if [[ "$pwr_profile" == "power-saver" ]]; then

          sus_pl=6000                              # Sustained Power Limit (mW)
          actual_pl=6000                           # ACTUAL Power Limit    (mW)
          avg_pl=6000                              # Average Power Limit   (mW)
          vrm_edc=90000                            # VRM EDC Current       (mA)
          max_tmp=75                               # Max Tctl              (C)

          "${pkgs.ryzenadj}"/bin/ryzenadj -a $sus_pl -b $actual_pl -c $avg_pl -k $vrm_edc -f $max_tmp > /dev/null

        elif [[ "$pwr_profile" != "$prev" ]]; then

          "${pkgs.power-profiles-daemon}"/bin/powerprofilesctl set "$pwr_profile"

        fi

        prev=$pwr_profile

        sleep 20

      done

    '';
  in {
    enable = true;
    script = "${ryzenadj}";
    wantedBy = ["default.target"];
  };
}
