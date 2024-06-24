{
  lib,
  inputs,
  username,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkEnableOption mkIf;
  cfg = config.myOptions.browsers;
in {
  options.myOptions.browsers = {
    chrome.enable = mkEnableOption "chromium";
    firefox.enable = mkEnableOption "firefox";
  };

  config = mkMerge [
    (mkIf cfg.chrome.enable {
      home-manager.users.${username}.programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    })
    (mkIf cfg.firefox.enable {
      home-manager.users.${username} = {
        home.packages = let
          pkg = pkgs.firefox;

          maybeTheme = opt: lib.findFirst builtins.isNull opt.package [opt opt.package];

          just' = v: lib.optional (v != null);

          just = v: just' v v;

          #gtkTheme = maybeTheme config.gtk.theme;

          #iconTheme = maybeTheme config.gtk.iconTheme;

          cursorTheme = maybeTheme config.home-manager.users.${username}.home.pointerCursor;

          mkNixPak = inputs.nixpak.lib.nixpak {
            inherit (pkgs) lib;
            inherit pkgs;
          };

          wrappedFirefox =
            (mkNixPak {
              config = {sloth, ...}: let
                appId = "org.mozilla.Firefox";
              in {
                flatpak = {
                  inherit appId;
                };
                app.package = pkg;

                dbus.policies = {
                  "${appId}" = "own";
                  "${appId}.*" = "own";
                  "org.a11y.Bus" = "talk";
                  "org.gnome.SessionManager" = "talk";
                  "org.freedesktop.ScreenSaver" = "talk";
                  "org.gtk.vfs.*" = "talk";
                  "org.gtk.vfs" = "talk";
                  "org.freedesktop.Notifications" = "talk";

                  "org.freedesktop.portal.FileChooser" = "talk";
                  "org.freedesktop.portal.Settings" = "talk";

                  "org.mpris.MediaPlayer2.firefox.*" = "own";
                  "org.mozilla.firefox.*" = "own";
                  "org.mozilla.firefox_beta.*" = "own";

                  "org.freedesktop.DBus" = "talk";
                  "org.freedesktop.DBus.*" = "talk";
                  "ca.desrt.dconf" = "talk";

                  "org.freedesktop.portal.*" = "talk";
                };

                gpu.enable = true;
                gpu.provider = "bundle";
                fonts.enable = true;
                locale.enable = true;

                etc.sslCertificates.enable = true;

                bubblewrap = {
                  network = true;

                  sockets = {
                    wayland = true;
                    pipewire = true;
                    pulse = true;
                  };
                  extraStorePaths = [
                    config.hardware.opengl.package # WebRender acceleration
                    config.hardware.opengl.extraPackages # Video acceleration
                  ];

                  bind.rw = [
                    (sloth.concat' sloth.xdgCacheHome "/fontconfig")
                    (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
                    (sloth.concat' sloth.runtimeDir "/gvfs")
                    (sloth.concat' sloth.runtimeDir "/gvfsd")
                    (sloth.concat' sloth.runtimeDir "/doc") # For the Document portal

                    (sloth.concat' sloth.homeDir "/.mozilla")
                  ];

                  bind.ro =
                    [
                      "/etc/resolv.conf"

                      (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
                      (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
                      (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
                      (sloth.concat' sloth.xdgConfigHome "/dconf")
                      "/etc/localtime"

                      "/sys/bus/pci"

                      [
                        "${pkg}/lib/firefox"
                        "/app/etc/firefox"
                      ]
                    ]
                    ++ just' cursorTheme "${cursorTheme}";
                  env = {
                    XDG_DATA_DIRS = lib.makeSearchPath "share" ([
                        pkgs.shared-mime-info
                      ]
                      #++ just iconTheme
                      #++ just gtkTheme
                      ++ just cursorTheme);
                    XCURSOR_PATH = lib.mkIf (cursorTheme != null) (lib.concatStringsSep ":" [
                      "${cursorTheme}/share/icons"
                      "${cursorTheme}/share/pixmaps"
                    ]);
                  };
                };
              };
            })
            .config
            .env;
        in [
          wrappedFirefox
        ];

        programs.firefox = {
          enable = true;
          package = null;

          policies = let
            extensions = {
              "uBlock0@raymondhill.net" = "ublock-origin";
              "@testpilot-containers" = "multiaccount-containers";
              "{3c078156-979c-498b-8990-85f7987dd929}" = "sidebery";
              "{9b84b6b4-07c4-4b4b-ba21-394d86f6e9ee}" = "black-theme";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
            };
          in {
            ExtensionSettings =
              lib.mapAttrs
              (_: name: {
                installation_mode = "normal_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
              })
              extensions;
          };

          profiles.default = {
            id = 0;
            name = "Default";
            isDefault = true;
            search = {
              force = true;
              default = "DuckDuckGo";
            };

            extraConfig = lib.strings.concatStrings [
              (builtins.readFile "${inputs.arkenfox-userjs}/user.js")
              ''
                // enable location bar search
                user_pref("keyword.enabled", true);
                // enable live search suggestions
                user_pref("browser.search.suggest.enabled", true);
                user_pref("browser.urlbar.suggest.searches", true);
                // keep data on shutdown
                //user_pref("privacy.clearOnShutdown.cookies", false);
                user_pref("privacy.clearOnShutdown.history", false);
                // Disable Pocket.
                pref("extensions.pocket.enabled", false);
                // resume previous session
                user_pref("browser.startup.page", 3);
                // never show bookmarks toolbar
                user_pref("browser.toolbars.bookmarks.visibility", "never");
                // disable firefox view
                user_pref("browser.tabs.firefox-view", false);
                //Enable userChrome customisations
                user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true)

                // bitwarden is used instead
                lockPref("signon.rememberSignons", false);
              ''
            ];
            # Inspired by https://github.com/linuxmobile/SilentFox/tree/main
            userChrome = ''
              /* Completely hide tabs */
              #TabsToolbar { visibility: collapse; }

              :root {
                --wide-tab-width: 300px;
                --thin-tab-width: 35px;
              }

              #sidebar-box > #browser,
              #webextpanels-window {
                background: var(--sidebar-background) !important;
              }

              /*Collapse in default state and add transition*/
              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"] {
                border-right: none !important;
                z-index: 2;
                border-right: none !important;
                width: 100% !important;
                background: var(--sidebar-background);

                /* lock sidebar to height by doing the inverse margin of the toolbar element */
                z-index: 1000 !important;
                position: relative !important;
                margin-top: 0px !important;
                border-right: none;
                transition: all 200ms !important;

                /* lock sidebar to specified width */
                min-width: var(--thin-tab-width) !important;
                max-width: var(--thin-tab-width) !important;
                overflow: hidden !important;
                transition-property: width;
                transition-duration: 0.3s;
                transition-delay: 0.3s;
                transition-timing-function: ease-in;
              }

              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]::after {
                background: #1c1b22 !important;
                margin-left: 207px;
                z-index: 9999999;
                position: absolute;
                content: " ";
                width: 1px;
                height: 100%;
                top: 0;
                right: 0px;
              }

              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]:hover:after {
                top: 42px;
              }

              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]:hover,
              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]
                #sidebar:hover {
                min-width: var(--wide-tab-width) !important;
                max-width: var(--wide-tab-width) !important;
                margin-right: calc(
                  (var(--wide-tab-width) - var(--thin-tab-width)) * -1
                ) !important;
                transition: all 200ms !important;
              }

              #sidebar-header {
                border: none !important;
                border-right: 1px solid var(--sidebar-border-color);
                background: var(--sidebar-background) !important;
              }

              #sidebar-close,
              #sidebar-title,
              #sidebar-switcher-arrow {
                display: none;
                border: none;
              }

              #sidebar-switcher-target {
                border: none !important;
                margin-left: 4.5px !important;
                padding-top: 4px !important;
                padding-bottom: 6px !important;
              }

              #sidebar-switcher-target:focus-visible:not(:hover, [open]),
              #sidebar-close:focus-visible:not(:hover, [open]) {
                outline: none !important;
              }

              .sidebar-splitter {
                opacity: 0 !important;
                width: 0px !important;
                border: none !important;
                --avatar-image-url: none !important;
              }

              #sidebarMenu-popup .subviewbutton {
                min-width: 0px;
                padding: 0;
                margin: 0 !important;
              }

              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]
                + #sidebar-splitter {
                display: none !important;
              }

              #sidebar-box[sidebarcommand="_3c078156-979c-498b-8990-85f7987dd929_-sidebar-action"]
                #sidebar-header {
                visibility: collapse;
              }
            '';
          };
        };
      };
    })
  ];
}
