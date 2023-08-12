{ pkgs
, ...
}: {
  imports = [
    ./flatpak
    ./nix
    ./security
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
      "quiet"
    ];
    # For gaming
    kernel.sysctl."vm.max_map_count" = 2147483642;

  };

  services.fstrim.enable = true;

  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };

  # Configure console keymap
  console.keyMap = "es";

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = [ "networkmanager" "wheel" "users" ];
  };

  programs.zsh.enable = true;
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
