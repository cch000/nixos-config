_: {
  imports = [
    #Kernel config related options
    ./kernel.nix
    #Networking related options
    ./networking.nix
    ./impermanence.nix
    ./pam.nix
    ./logging.nix
    #options that do not fit anywhere else
    ./misc.nix
  ];
}
