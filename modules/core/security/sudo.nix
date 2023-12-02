{lib, ...}: {
  security = {
    sudo.enable = lib.mkForce false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
