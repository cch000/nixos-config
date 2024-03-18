{lib, ...}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./services.nix
    ./virtualisation.nix
  ];

  security.rtkit.enable = true;
  #Rip out the default packages
  environment.defaultPackages = lib.mkForce [];
}
