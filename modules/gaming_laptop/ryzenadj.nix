{
  pkgs,
  inputs,
  lib,
  ...
}: {
  systemd.services.ryzenadj = {
    enable = true;
    serviceConfig.ExecStart = lib.getExe' inputs.power-cap-rs.packages.x86_64-linux.default "pwr-cap-rs";
    path = with pkgs; [ryzenadj power-profiles-daemon];
    wantedBy = ["default.target"];
    #script = builtins.readFile ./ryzenadj.sh;
  };
}
