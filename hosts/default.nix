{ nixpkgs
, self
, ...
}:
let
  inherit (self) inputs;
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  sound = ../modules/sound;
  gnome = ../modules/gnome;
  gaming_laptop = ../modules/gaming_laptop;
  virtualisation = ../modules/virtualisation;
  university = ../modules/university/default.nix;
  hm_module = inputs.home-manager.nixosModules.home-manager;
  inherit (inputs.impermanence.nixosModules) impermanence;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.cch = ../modules/users/cch;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
  };
in
{
  athena = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      { networking.hostName = "athena"; }
      ./athena/hardware-configuration.nix
      nvidia
      core
      gaming_laptop
      gnome
      sound
      virtualisation
      impermanence
      university
      hm_module
      { inherit home-manager; }
    ];
  };
}
