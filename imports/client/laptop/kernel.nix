{
  pkgs,
  lib,
  ...
}: let
  custom = let
    baseKernel = pkgs.linux;
    suffix = "-bore";
  in
    pkgs.linuxManualConfig {
      inherit (baseKernel) src;
      modDirVersion = "${baseKernel.modDirVersion}${suffix}";
      version = "${baseKernel.version}${suffix}";
      allowImportFromDerivation = true;

      # generated using modprobed-db and
      # make LSMOD=$HOME/.config/modprobed.db localmodconfig
      configfile =
        #https://github.com/NixOS/nixpkgs/issues/307014
        builtins.toPath
        (builtins.toFile "config" (
          lib.strings.concatLines [
            (builtins.readFile ./config)
            "CONFIG_MZEN3=y"
          ]
        ));

      kernelPatches = [
        {
          name = "BORE CPU scheduler";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/firelzrd/bore-scheduler"
              + "/main/patches/stable"
              + "/linux-6.6-bore/0001-linux6.6.30-bore5.1.8.patch";
            hash = "sha256-iXYDquRhqHpCg6vF72D2SzQ1F82dLY+76H+FrtAQuxE=";
          };
        }
        {
          name = "Native CPU optimizations";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/graysky2/kernel_compiler_patch"
              + "/master/more-uarches-for-kernel-6.1.79-6.8-rc3.patch";
            hash = "sha256-Gjglt5BBPQmAbJohFfZ5vijkNM/MacAdwGm2NNHoAHo=";
          };
          #extraStructuredConfig = with lib.kernel; {
          #  GENERIC_CPU = mkForce no;
          #  MZEN3 = mkForce yes;
          #};
        }
      ];
    };

  #https://github.com/NixOS/nixpkgs/issues/216529
  passthru = {
    features = {
      efiBootStub = true;
      ia32Emulation = true;
      iwlwifi = true;
      needsCifsUtils = true;
      netfilterRPFilter = true;
    };
  };
  finalKernel = custom.overrideAttrs (old: {
    passthru = old.passthru // passthru;
  });
in {
  #https://github.com/NixOS/nixpkgs/issues/154163
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];
  boot = {
    kernelPackages = pkgs.linuxPackagesFor finalKernel;
  };
}
