{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez-experimental;
  };

  services.blueman.enable = true;
}
