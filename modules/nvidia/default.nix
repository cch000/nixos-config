_: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
    };
  };
}
