{lib, ...}: {
  boot = {
    #Make /tmp volatile by mounting it in ram
    tmp = {
      useTmpfs = lib.mkDefault true;
    };
    # See description in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
  };
}
