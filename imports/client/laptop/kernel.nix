{
  pkgs,
  lib,
  ...
}: let
  custom = let
    baseKernel = pkgs.linux;
    suffix = "-athena";
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
            (builtins.replaceStrings
              #from
              [
                "CONFIG_X86_EXTENDED_PLATFORM=y"
                "CONFIG_X86_MCE_INTEL=y"
                "CONFIG_PREEMPT_VOLUNTARY=y"
                ''CONFIG_LOCALVERSION=""''
              ]
              #to
              [
                "CONFIG_X86_EXTENDED_PLATFORM=n"
                "CONFIG_X86_MCE_INTEL=n"
                "CONFIG_PREEMPT_VOLUNTARY=n"
                ''CONFIG_LOCALVERSION="${suffix}"''
              ]
              (builtins.readFile ./config))
            #add
            "CONFIG_MZEN3=y"
            "CONFIG_PREEMPT=y"
          ]
        ));

      kernelPatches = [
        {
          name = "BORE CPU scheduler";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/firelzrd/bore-scheduler"
              + "/main/patches/stable/linux-6.6-bore"
              + "/0001-linux6.6.57-bore5.7.2.patch";
            hash = "sha256-UkwKs8latDnpNPhPsbvJ4wxu2buQhiWrLuv6u9JKF6g=";
          };
        }
        {
          name = "bbr v3";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/CachyOS/kernel-patches/refs/heads/master/6.6"
              + "/0001-bbr3.patch";
            hash = "sha256-hu/to3Oo/ppIRC/iczNxWdnmJ1dmTeA0yUaGULkfMlE=";
          };
        }

        {
          name = "zstd optimizations";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/CachyOS/kernel-patches"
              + "/refs/heads/master/6.6/0005-zstd.patch";
            hash = "sha256-onNd7OdkBnXYW3xyUVvxhXt0kqW5SQF1Wz2iJKVSLWk=";
          };
        }
        # Provides syscalls for uksmd. uksmd does identify same memory pages and merges them
        {
          name = "ksm";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/CachyOS/kernel-patches/refs/heads/master/6.6/"
              + "0004-ksm.patch";
            hash = "sha256-4cnHLbjNxFGAxcYfCI28A+IoFcntxBXeG7eUj8cbQcA=";
          };
        }
        {
          name = "fixes";
          patch = pkgs.fetchurl {
            url =
              "https://raw.githubusercontent.com"
              + "/CachyOS/kernel-patches/refs/heads/master/6.6/"
              + "0003-fixes.patch";
            hash = "sha256-v6il4epclV6ehGhG+S8Lxqg3OR5HQGUz+EWFUZTnC7E=";
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
    #kernelPackages = pkgs.linuxPackages;
  };
}
