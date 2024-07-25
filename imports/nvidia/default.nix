{
  config,
  pkgs,
  ...
}:
#example of let block and package version override
let
  version = "550.100";
  my-nvidia = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs {
    inherit version;
    name = "nvidia-${version}";
    src = pkgs.fetchurl {
      url = "https://download.nvidia.com/XFree86/Linux-x86_64/${version}/NVIDIA-Linux-x86_64-${version}.run";
      sha256 = "sha256-imtfsoe/EfUFZzR4S9pkwQZKCcKqefayJewPtW0jgC0=";
    };
  };
in {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      dynamicBoost.enable = true;
      nvidiaSettings = false;
      package = my-nvidia;
    };
  };
}
