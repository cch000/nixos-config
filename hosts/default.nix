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
  modules = ../modules;
  hm_module = inputs.home-manager.nixosModules.home-manager;
in {
  athena = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {networking.hostName = "athena";}
      ./athena
      modules
      nvidia
      core
      client
      laptop
      hm_module
    ];
    specialArgs = {
      inherit self inputs;
      username = "cch";
    };
  };
}
