{inputs, ...}: {
  #systemd.services.ryzenadj = {
  #  enable = true;
  #  serviceConfig.ExecStart = lib.getExe inputs.power-cap-rs.packages.x86_64-linux.default;
  #  wantedBy = ["default.target"];
  #  #script = builtins.readFile ./ryzenadj.sh;
  #};

  imports = [
    inputs.power-cap-rs.nixosModules.pwr-cap-rs
  ];

  services.pwr-cap-rs = {
    enable = true;
    stapm-limit = 7000;
    fast-limit = 7000;
    slow-limit = 7000;
  };
}
