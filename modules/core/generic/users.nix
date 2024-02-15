{pkgs, ...}: {
  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = [
      "networkmanager"
      "wheel"
      "users"
      "dialout" #for arduino development
    ];
    shell = pkgs.zsh;
  };
}
