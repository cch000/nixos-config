{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.myOptions.zsh;
in {
  options.myOptions.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # starship prompt
      promptInit = ''
        eval "$(${lib.getExe pkgs.starship} init zsh)"
      '';
    };

    home-manager.users.${username}.programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        oh-my-zsh.enable = true;

        sessionVariables = {
          ZSH_AUTOSUGGEST_USE_ASYNC = "true";
        };

        shellAliases = with pkgs; {
          code = "${lib.getExe vscodium}";
        };

        initExtra = ''
          # Vi mode
          bindkey -v

          bindkey "^A" vi-beginning-of-line
          bindkey "^E" vi-end-of-line

          bindkey '^[k' autosuggest-accept
        '';
      };
      starship = {
        enable = true;
        settings = {
          add_newline = false;
        };
      };
    };
  };
}
