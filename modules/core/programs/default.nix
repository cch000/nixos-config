_: {
  # enable direnv
  programs = {
    direnv = {
      enable = true;
      silent = true;
      # faster, permanent implementation of use_nix and use_flake
      nix-direnv.enable = true;
    };
  };
}
