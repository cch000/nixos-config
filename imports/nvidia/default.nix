{config, ...}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
