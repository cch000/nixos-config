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

  mkHosts = builtins.mapAttrs (hostName: {
    username,
    system ? "x86_64-linux",
    extraImports,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          {networking = {inherit hostName;};}
          ./${hostName}
          options
          core
          hm_module
        ]
        ++ extraImports;
      specialArgs = {
        inherit inputs username;
      };
    });
in
  mkHosts {
    athena = {
      username = "cch";
      extraImports = [laptop client nvidia];
    };
  }
