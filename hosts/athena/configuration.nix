{
  pkgs,
  username,
  ...
}: {
  myOptions = {
    other = {
      home-manager.enable = true;
      defaultPrograms.enable = true;
    };

    services.ollama = {
      enable = true;
      onlyOnAc = true;
      ollamaEnableHyprlandKey = true;
      ollamaModelHyprlandKey = "codellama:13b";
    };

    cli = {
      git.enable = true;
      zsh.enable = true;
    };
    gui = {
      steam.enable = true;
      browsers = {
        firefox = true;
        chrome = true;
      };
      vscodium.enable = true;
      foot.enable = true;
    };

    tui = {
      fancyNvim.enable = true;
    };

    rice.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "me";
    extraGroups = [
      "networkmanager"
      "wheel"
      "users"
      "dialout" #for arduino development
    ];
    shell = pkgs.zsh;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = false;

    #kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=passive"
      "quiet"
    ];
    # For gaming
    kernel.sysctl."vm.max_map_count" = 2147483642;
  };
  # Tweaks CPU scheduler for responsiveness over throughput.
  programs.cfs-zen-tweaks.enable = true;
}
