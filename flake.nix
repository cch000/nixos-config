{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      lib = nixpkgs.lib;

      base = [
        ./system/configuration.nix
        ./system/flatpak.nix
      ];

      g14 = [
        ./system/nvidia.nix
        ./system/g14.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cch = import ./home/home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];

    in
    {
      nixosConfigurations = {
        g14 = lib.nixosSystem {
          inherit system;

          modules = base ++ g14;
        };
      };

      formatter = {
        x86_64-linux = pkgs.x86_64-linux.alejandra;
        aarch64-linux = pkgs.aarch64-linux.alejandra;
      };
    };
}
