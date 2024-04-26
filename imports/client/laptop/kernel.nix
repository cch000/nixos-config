{pkgs, ...}: let
  custom = let
    baseKernel = pkgs.linux;
    suffix = "-bore";
  in
    pkgs.linuxManualConfig {
      inherit (baseKernel) src;
      modDirVersion = "${baseKernel.modDirVersion}${suffix}";
      version = "${baseKernel.version}${suffix}";
      configfile = ./config;
      allowImportFromDerivation = true;

      kernelPatches = [
        {
          name = "BORE CPU scheduler";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/firelzrd/bore-scheduler"
              + "/main/patches/stable"
              + "/linux-6.6-bore/0001-linux6.6.y-bore5.1.0.patch";
            hash = "sha256-iLydPGZZSkEQhSj6Ah0Xq0zf7YUPwcpyKt8t0BeHYz8=";
          };
        }
        {
          name = "Native CPU optimizations";
          patch = null;
          extraMakeFlags = let
            architecture = "znver3";
          in [
            "-march=${architecture}"
            "-mtune=${architecture}"
          ];
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
  finalKernel = custom.overrideAttrs (old: {passthru = old.passthru // passthru;});
in {
  #https://github.com/NixOS/nixpkgs/issues/154163
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];
  boot = {
    kernelPackages = pkgs.linuxPackagesFor finalKernel;
  };
}
