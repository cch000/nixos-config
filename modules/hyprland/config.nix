{
  config,
  lib,
  username,
  pkgs,
  ...
}: let
  pointer = config.home-manager.users.${username}.home.pointerCursor;
  inherit (lib) mkIf;
  cfg = config.myOptions.hyprland;
  inherit (config.myScripts) pwrprofilecycle lock;
in {
  config = mkIf cfg.enable {
    programs.hyprland.enable = true;

    environment = {
      systemPackages = with pkgs; [brightnessctl hyprnome];
      variables = {
        GDK_SCALE = "2";
      };
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    home-manager.users.${username}.wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        "$mainMod" = "SUPER";

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          # set cursor for HL itself
          "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
        ];

        gestures = {
          workspace_swipe = true;
        };

        input = {
          kb_layout = "es";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = "yes";
          };
        };

        decoration = {
          rounding = 0;
          blur.enabled = false;
          drop_shadow = false;
        };
        animations = {
          enabled = true;
          first_launch_animation = false;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        xwayland = {
          force_zero_scaling = true;
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 0;
          gaps_out = 0;
          border_size = 3;
          "col.active_border" = "rgba(ff7800FF)";
          "col.inactive_border" = "rgba(000000FF)";

          apply_sens_to_raw = 0;
        };

        debug = {
          disable_logs = false;
        };

        misc = {
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;

          vrr = 1;
          vfr = true;

          # window swallowing
          enable_swallow = true; # hide windows that spawn other windows
          swallow_regex = "foot"; # windows for which swallow is applied

          # dpms
          #mouse_move_enables_dpms = true; # enable dpms on mouse/touchpad action
          key_press_enables_dpms = true; # enable dpms on keyboard action
          disable_autoreload = true; # autoreload is unnecessary on nixos, because the config is readonly anyway
        };
        bind = [
          "$mainMod, Print, exec, ${lib.getExe pkgs.grimblast} copysave output"
          ", Print, exec, ${lib.getExe pkgs.grimblast} copysave area"

          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86Launch4, exec, ${lib.getExe pwrprofilecycle} -n; pkill -SIGRTMIN+8 waybar"

          "$mainMod, B, exec, ${lib.getExe lock}"

          "$mainMod, T, exec, foot"
          "$mainMod, Q, killactive,"
          "$mainMod, O, exec, loginctl terminate-user $(whoami)"
          "$mainMod, F, exec, nautilus"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, wofi --show drun"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, S, togglesplit, # dwindle"

          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"

          "$mainMod, A, exec, hyprnome --previous"
          "$mainMod, S, exec, hyprnome"
          "$mainMod SHIFT, A, exec, hyprnome --previous --move"
          "$mainMod SHIFT, S, exec, hyprnome --move"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, hyprnome"
          "$mainMod, mouse_up, workspace, hyprnome --previous"
        ];
        binde = [
          ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

          ", XF86KbdBrightnessUp, exec, brightnessctl set -d asus::kbd_backlight 33%+"
          ", XF86KbdBrightnessDown, exec, brightnessctl set -d asus::kbd_backlight 33%-"

          "$mainMod CONTROL, H, resizeactive, -10 0"
          "$mainMod CONTROL, L, resizeactive, 10 0"
          "$mainMod CONTROL, K, resizeactive, 0 -10"
          "$mainMod CONTROL, J, resizeactive, 0 10"
        ];
        bindr = "SUPER, SUPER_L, exec, pkill wofi || wofi --show drun -a";
        bindm = ["$mainMod, mouse:272, movewindow" "$mainMod, mouse:273, resizewindow"];
      };
    };
  };
}
