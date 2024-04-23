{
  lib,
  config,
  ...
}: let
  inherit (config.boot.tmp) useTmpfs;
in {
  boot = {
    #Make /tmp volatile by mounting it in ram
    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = !useTmpfs;
    };
    # See description in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
  };
}
