{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];

  services.supergfxd = {
    enable = true;
  };

  systemd.services.supergfxd.path = [pkgs.kmod pkgs.pciutils];

  services.asusd.enable = true;
}
