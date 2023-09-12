{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };

    libvirtd.enable = true;
  };

  environment.systemPackages = with pkgs; [virt-manager];

  users.users.cch.extraGroups = ["libvirtd"];
}
