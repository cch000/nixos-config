{pkgs, ...}: {
  systemd.services.ryzenadj = {
    enable = true;
    script = builtins.readFile ./ryzenadj.sh;
    path = with pkgs; [ryzenadj power-profiles-daemon];
    wantedBy = ["default.target"];
  };
}
