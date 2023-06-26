{ nixpkgs, self, ... }:

let
  inherit (self) inputs;
  core = ../modules/core;
  nvidia = ../modules/nvidia;
  laptop = ../modules/laptop;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.cch = ../modules/users;
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
      { inherit home-manager; }
    ];
  };
}
