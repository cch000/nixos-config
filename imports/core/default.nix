{lib, ...}: {
  imports = [
    ./locale.nix
    ./nix.nix
    ./services.nix
    ./virtualisation.nix

    #kernel config related options
    ./kernel.nix
    #networking related options
    ./networking.nix

    ./impermanence.nix
    ./pam.nix
    ./logging.nix
    ./sudo.nix
    ./tmp.nix
  ];

  security.rtkit.enable = true;
  #Rip out the default packages
  environment.defaultPackages = lib.mkForce [];
}
