_: {
  programs.git = {
    enable = true;
    userName = "Carlos";
    userEmail = "carloscamposherrera446@gmail.com";
    signing = {
      key = "E56E50F86E9F5DC9";
      signByDefault = true;
    };
    extraConfig = {
      core.editor = "nvim";
    };
  };
}
