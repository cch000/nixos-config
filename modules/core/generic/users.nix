{pkgs, ...}: {
  users.users.cch = {
    isNormalUser = true;
    description = "cch";
    extraGroups = ["networkmanager" "wheel" "users"];
    shell = pkgs.zsh;
  };
}
