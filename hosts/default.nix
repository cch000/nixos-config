{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  laptop = ../modules/laptop;
  hm_module = inputs.home-manager.nixosModules.home-manager;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.cch = ../modules/users/cch;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
  };
in {
  athena = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {networking.hostName = "athena";}
      ./athena/hardware-configuration.nix
      nvidia
      core
      hm_module
      laptop
      {inherit home-manager;}
    ];
  };
}
