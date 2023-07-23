{ pkgs
, lib
, config
, ...
}: {

  imports = [
    #Kernel related options
    ./kernel.nix
    #Networking related options
    ./networking.nix
  ];

  security = {
    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    # Disable unprivileged user namespaces, unless containers are enabled
    unprivilegedUsernsClone = config.virtualisation.containers.enable;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    # virtualisation
    virtualisation = {
      #  flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };

    # log polkit request actions
    # polkit handles the policy that allows unprivileged processes to speak to privileged processes
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });
    '';

    pam = {
      # fix "too many files open"
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];
    };

    auditd.enable = true;
    audit.enable = true;
    audit.rules = [
      "-a exit,always -F arch=b64 -S execve"
    ];
    sudo.execWheelOnly = true;
  };

  #Rip out the default packages
  environment.defaultPackages = lib.mkForce [ ];

  boot = {
    #Make /tmp volatile by mounting it in ram
    tmp.useTmpfs = lib.mkDefault true;
    # See description in nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
    loader.systemd-boot.editor = false;
  };

  nix.settings.allowed-users = [ "@wheel" ];
}
