{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs {
        src = pkgs.fetchurl {
          url = "https://download.nvidia.com/XFree86/Linux-x86_64/535.129.03/NVIDIA-Linux-x86_64-535.129.03.run";
          sha256 = "sha256-5tylYmomCMa7KgRs/LfBrzOLnpYafdkKwJu4oSb/AC4=";
        };
      };
    };
  };
}
