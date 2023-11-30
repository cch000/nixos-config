{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./flatpak
    ./nix
    ./security
    ./programs
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = false;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=passive"
      #"amdgpu.noretry=0"
      "quiet"
    ];
    # For gaming
    kernel.sysctl."vm.max_map_count" = 2147483642;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.fstrim.enable = true;

  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  # Configure console keymap
  console.keyMap = "es";

  security.rtkit.enable = true;

  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = ["networkmanager" "wheel" "users"];
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
    zsh.enable = true;
    gnupg.agent.enable = true;
  };

  users.users.cch.shell = pkgs.zsh;

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
}
