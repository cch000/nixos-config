_: {
  imports = [
    #Kernel config related options
    ./kernel.nix
    #Networking related options
    ./networking.nix
    ./impermanence.nix
    ./pam.nix
    ./logging.nix
    ./sudo.nix
    ./tmp.nix
  ];
}
