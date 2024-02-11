{
  pkgs,
  self,
  lib,
  ...
}: {
  systemd.services.ryzenadj = {
    enable = true;
    serviceConfig.ExecStart = lib.getExe' self.packages.x86_64-linux.pwr-cap-rs "pwr-cap-rs";
    path = with pkgs; [ryzenadj power-profiles-daemon];
    wantedBy = ["default.target"];
  };
}
