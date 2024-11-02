{pkgs, ...}: let
  bluez = pkgs.bluez-experimental;
in {
  hardware.bluetooth = {
    enable = true;
    package = bluez;
  };
  systemd.user.services.mpris-proxy = {
    enable = true;
    unitConfig = {
      Description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
      BindsTo = ["bluetooth.target"];
      After = ["bluetooth.target"];
    };

    wantedBy = ["bluetooth.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${bluez}/bin/mpris-proxy";
    };
  };
  services.blueman.enable = true;
}
