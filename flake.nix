{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations = import ./hosts inputs;
    formatter.x86_64-linux = pkgs.alejandra;
  };
}
