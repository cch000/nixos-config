{
  pkgs,
  username,
  ...
}: {
  myOptions = {
    home-manager.enable = true;
    defaultPrograms.enable = true;

    ollama = {
      enable = false;
      enableOnBoot = false;
      ollamaEnableHyprlandKey = true;
      ollamaModelHyprlandKey = "codellama:13b";
    };

    git.enable = true;
    zsh.enable = true;
    steam.enable = true;
    browsers = {
      firefox.enable = true;
      chrome.enable = true;
    };
    vscodium.enable = true;
    foot.enable = true;

    fancyNvim.enable = true;

    hyprland.enable = true;
    waybar.enable = true;
    wofi.enable = true;
    rice-services.enable = true;
    theme.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "me";
    extraGroups = [
      "networkmanager"
      "wheel"
      "users"
    ];
    shell = pkgs.zsh;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    #kernelPackages = pkgs.linuxPackages_latest;

    plymouth.enable = false;

    kernelParams = [
      "amd_pstate=passive"
      "quiet"
    ];
    kernel.sysctl = {
      # For gaming
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 10;
    };
  };
  # Tweaks CPU scheduler for responsiveness over throughput.
  programs.cfs-zen-tweaks.enable = true;
}
