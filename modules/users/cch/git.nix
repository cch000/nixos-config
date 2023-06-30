{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Carlos";
    userEmail = "carloscamposherrera446@gmail.com";
    extraConfig = {
      core.editor = "nvim";
    };
  };
}
