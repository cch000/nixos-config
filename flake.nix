{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    waybar.url = "github:Alexays/Waybar";
    impermanence.url = "github:nix-community/impermanence";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vim-eva01 = {
      url = "github:hachy/eva01.vim";
      flake = false;
    };

    vim-img-paste = {
      url = "github:img-paste-devs/img-paste.vim";
      flake = false;
    };
  };
  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      systems = ["x86_64-linux"];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            shfmt.enable = true;
            shellcheck.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inputsFrom = [config.treefmt.build.devShell];

          packages = with pkgs; [
            nil
          ];
        };
      };
      flake.nixosConfigurations = import ./hosts inputs;
    });
}
