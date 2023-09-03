{ pkgs
, ...
}: {
  # services.mongodb = {
  #   enable = true;
  # };

  environment.systemPackages = with pkgs; [ postman chromium];

  programs.pandoc.enable = true;

}
