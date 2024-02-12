{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  wayland = ../modules/wayland;
  gaming_laptop = ../modules/gaming_laptop;
  university = ../modules/university;
  hm_module = inputs.home-manager.nixosModules.home-manager;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.cch = ../home/cch;
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
      gaming_laptop
      wayland
      university
      hm_module
      {inherit home-manager;}
    ];
    specialArgs = {
      inherit inputs;
      inherit self;
    };
  };
}
