# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/136edf89-f560-4ccd-9177-f4bcfe02a39f";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  boot.initrd.luks.devices."enc" = {
    device = "/dev/disk/by-uuid/8ed52442-0753-4ebf-8cea-b98bc66b8225";
    allowDiscards = true;
  };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/136edf89-f560-4ccd-9177-f4bcfe02a39f";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/136edf89-f560-4ccd-9177-f4bcfe02a39f";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-uuid/136edf89-f560-4ccd-9177-f4bcfe02a39f";
      fsType = "btrfs";
      options = [ "subvol=persist" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    {
      device = "/dev/disk/by-uuid/136edf89-f560-4ccd-9177-f4bcfe02a39f";
      fsType = "btrfs";
      options = [ "subvol=log" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/7CB6-9876";
      fsType = "vfat";
      options = [ "noatime" ];
    };


  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
