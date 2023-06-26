{
  config,
  pkgs,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=passive"
      "quiet"
    ];
    kernel.sysctl."vm.max_map_count" = 2147483642;

    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };

  networking = {
    networkmanager.enable = true;
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "es";
      xkbVariant = "";
      excludePackages = [pkgs.xterm];
    };
    gnome.core-utilities.enable = false; #Minimal gnome install
  };

  hardware.opengl.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  programs.dconf.enable = true;

  # Configure console keymap
  console.keyMap = "es";

  #fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = ["networkmanager" "wheel"];
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
