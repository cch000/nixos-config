{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./flatpak.nix
    ./configuration.nix
    ./nix.nix
    ./security.nix
  ];
}
