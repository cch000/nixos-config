{ pkgs
, ...
}: {

  programs.pandoc.enable = true;

  home.packages = with pkgs; [
    postman
    chromium
  ];
}
