_: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      #Don't warn me about the dirty git tree
      warn-dirty = false;
      allowed-users = ["@wheel"];
      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = ["daily"];
    };
  };

  systemd.services = let
    onlyOnAc = builtins.mapAttrs (_service: config:
      config
      // {unitConfig.ConditionACPower = true;});
  in
    onlyOnAc {
      nix-optimise = {};
      nix-gc = {};
    };

  documentation = {
    doc.enable = false;
    info.enable = false;
    dev.enable = false;
    nixos = {
      enable = false;
      includeAllModules = true;
    };
    man = {
      enable = false;
      generateCaches = true;
    };
  };

  system.stateVersion = "23.05"; # Do not change this
}
