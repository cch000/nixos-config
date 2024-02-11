use std::{
    process::Command,
    thread::sleep,
    time::{self, Duration},
};

struct RyzenadjValues {
    sus_pl: i32,    // Sustained Power Limit (mW)
    actual_pl: i32, // ACTUAL Power Limit    (mW)
    avg_pl: i32,    // Average Power Limit   (mW)
    vrm_edc: i32,   // VRM EDC Current       (mA)
    max_tmp: i32,   // Max Tctl              (C)
}

fn main() {
    const POWER_SAVER: RyzenadjValues = RyzenadjValues {
        sus_pl: 7000,
        actual_pl: 7000,
        avg_pl: 7000,
        vrm_edc: 90000,
        max_tmp: 70,
    };

    const NAP_TIME: Duration = time::Duration::from_secs(20);

    let mut prev = String::new();

    loop {
        sleep(NAP_TIME);

        let power_profile = Command::new("powerprofilesctl")
            .arg("get")
            .output()
            .expect("Failed to execute powerprofiles get");

        let output = String::from_utf8_lossy(&power_profile.stdout)
            .trim()
            .to_owned();

        if output == "power-saver" {
            let ryzenadj = Command::new("ryzenadj")
                .args(&[
                    format!("-a {0}", POWER_SAVER.sus_pl),
                    format!("-b {0}", POWER_SAVER.actual_pl),
                    format!("-c {0}", POWER_SAVER.avg_pl),
                    format!("-k {0}", POWER_SAVER.vrm_edc),
                    format!("-f  {0}", POWER_SAVER.max_tmp),
                ])
                .output()
                .expect("Failed to execute ryzenadj");

            if !ryzenadj.status.success() {
                eprintln!("Ryzenadj failed to apply parameters");
            }

            continue;
        }

        if output != prev {
            let set_power_profile = Command::new("powerprofilesctl")
                .args(&["set", &format!("{0}", output)])
                .status()
                .expect("Failied to execute powerprofiles set");

            if !set_power_profile.success() {
                eprintln!("Failed to apply power profiles");
            }
        }

        prev = output;
    }
}
