{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;

  core = ../imports/core;
  nvidia = ../imports/nvidia;
  client = ../imports/client;
  laptop = ../imports/client/laptop;
  options = ../modules;
  hm_module = inputs.home-manager.nixosModules.home-manager;

  mkHost = hostName: config:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          {networking = {inherit hostName;};}
          ./${hostName}
          options
          core
          hm_module
        ]
        ++ config.addModules;
      specialArgs = {
        inherit inputs;
        inherit (config) username;
      };
    };
in
  builtins.mapAttrs mkHost {
    athena = {
      username = "cch";
      addModules = [laptop client nvidia];
    };
  }
