{pkgs, ...}: {
  systemd.services.pwr-manage = {
    enable = true;
    script = builtins.readFile ./pwr-manage.sh;
    path = with pkgs; [power-profiles-daemon inotify-tools];
    after = ["cpufreq.service" "ryzenadj.service"];
    wantedBy = ["default.target"];
  };
}
