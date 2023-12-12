{
  lib,
  pkgs,
  ...
}: {
  programs = {
    # enable direnv
    direnv = {
      enable = true;
      silent = true;
      # faster, permanent implementation of use_nix and use_flake
      nix-direnv.enable = true;
    }; 
    zsh.enable = true;
    gnupg.agent.enable = true;

    # starship prompt
    zsh = {
      promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init zsh)"
      '';
    };
  };
}
