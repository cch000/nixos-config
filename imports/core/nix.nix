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
      options = "--delete-older-than 10d";
    };

    optimise = {
      automatic = true;
      dates = ["daily"];
    };
  };

  systemd.services = let
    onlyOnAc = builtins.mapAttrs (service: config:
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
    dev.enable = true;
    nixos = {
      enable = true;
      includeAllModules = true;
    };
    man = {
      enable = true;
      generateCaches = true;
    };
  };

  system.stateVersion = "23.05"; # Do not change this
}
