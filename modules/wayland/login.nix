{pkgs, ...}: {
  # unlock GPG keyring on login
  security.pam.services = {
    login = {
      enableGnomeKeyring = true;
      gnupg = {
        enable = true;
        noAutostart = true;
        storeOnly = true;
      };
    };

    greetd = {
      gnupg.enable = true;
      enableGnomeKeyring = true;
    };
  };

  systemd = {
    user.services.polkit-pantheon-authentication-agent-1 = {
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend
      '';
    };
  };
  security.polkit.enable = true;
}
