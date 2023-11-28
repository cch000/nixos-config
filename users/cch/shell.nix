{config, pkgs, lib, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      sessionVariables = {
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
      };

      shellAliases = with pkgs; {
        code = "${lib.getExe vscodium}";
      };

      initExtra = ''
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
  home = {
    sessionVariables = {
      STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
    };
  };
}
