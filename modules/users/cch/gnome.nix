{
  lib,
  pkgs,
  ...
}: {
  #Mainly dconf settings that affect gnome

  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell
    gnomeExtensions.unite
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.user-themes
    gruvbox-gtk-theme
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "Gruvbox-Dark-BL";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      minimize = ["<Super>a"];
      show-desktop = ["<Super>d"];
      switch-applications = [];
      switch-applications-backward = [];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "terminator";
      name = "terminator";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "Launch4";
      command = "asusctl profile -n";
      name = "profiles";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1200;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
      ];
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "pop-shell@system76.com"
        "unite@hardpixel.eu"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = true;
      app-menu = true;
      app-menu-icon = true;
      app-menu-label = true;
      background-menu = true;
      clock-menu = true;
      controls-manager-spacing-size = 0;
      dash = false;
      dash-icon-size = 0;
      dash-separator = false;
      hot-corner = true;
      panel = true;
      panel-arrow = false;
      panel-corner-size = 1;
      panel-in-overview = true;
      ripple-box = false;
      search = false;
      show-apps-button = false;
      startup-status = 0;
      theme = false;
      window-demands-attention-focus = true;
      window-picker-icon = true;
      window-preview-caption = false;
      workspace = true;
      workspace-switcher-should-show = true;
      workspaces-in-app-grid = true;
      world-clock = false;
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = false;
      gap-inner = lib.hm.gvariant.mkUint32 0;
      gap-outer = lib.hm.gvariant.mkUint32 0;
      tile-by-default = true;
    };

    "org/gnome/shell/extensions/unite" = {
      enable-titlebar-actions = false;
      extend-left-box = false;
      hide-activities-button = "always";
      hide-window-titlebars = "always";
      notifications-position = "center";
      restrict-to-primary-screen = false;
      show-desktop-name = false;
      show-legacy-tray = true;
      show-window-buttons = "never";
      show-window-title = "never";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = false;
      speed = 0.0;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      edge-scrolling-enabled = false;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = false;
    };
  };
}
