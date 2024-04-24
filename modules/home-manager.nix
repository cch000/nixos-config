{
  config,
  inputs,
  username,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.myOptions.home-manager;
in {
  options.myOptions.home-manager = {
    enable = mkEnableOption "home-manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs;
      };
      users.${username} = {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = mkDefault "23.05"; #Do not change this
        };

        programs.home-manager.enable = true;
      };
    };
  };
}
