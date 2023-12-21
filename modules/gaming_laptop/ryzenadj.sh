#!/usr/bin/env bash

prev=0

while true; do

    sleep 20

    pwr_profile=$(powerprofilesctl get)

    if [[ "$pwr_profile" == "power-saver" ]]; then

        sus_pl=7000    # Sustained Power Limit (mW)
        actual_pl=7000 # ACTUAL Power Limit    (mW)
        avg_pl=7000    # Average Power Limit   (mW)
        vrm_edc=90000  # VRM EDC Current       (mA)
        max_tmp=75     # Max Tctl              (C)

        ryzenadj -a $sus_pl -b $actual_pl -c $avg_pl -k $vrm_edc -f $max_tmp >/dev/null

    elif [[ "$pwr_profile" != "$prev" ]]; then

        powerprofilesctl set "$pwr_profile"

    fi

    prev=$pwr_profile

done
