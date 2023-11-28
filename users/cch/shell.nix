{config, ...}: {
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      sessionVariables = {
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
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
