{
  lib,
  pkgs,
  ...
}: let
  # taken from https://github.com/fufexan/dotfiles/blob/main/home/services/swayidle.nix
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  # screen idle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 330;
        command = suspendScript.outPath;
      }
    ];
  };
}
