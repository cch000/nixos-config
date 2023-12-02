{lib, ...}: {
  security = {
    # virtualisation
    virtualisation = {
      #  flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };
    rtkit.enable = true;
  };

  #Rip out the default packages
  environment.defaultPackages = lib.mkForce [];

  boot = {
    #Make /tmp volatile by mounting it in ram
    tmp.useTmpfs = lib.mkDefault true;
    # See description in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
  };
}
