{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkEnableOption types mkOption mkIf mkForce mkMerge strings;
  cfg = config.myOptions.ollama;
in {
  options.myOptions.ollama = {
    enable = mkEnableOption "ollama";
    onlyOnAc = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Wether to stop the service when the laptop is not plugged in
      '';
    };
    ollamaEnableHyprlandKey = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Wether to launch a foot instance with a model running in ollama. Keybind: $mainMod, z
      '';
    };
    ollamaModelHyprlandKey = mkOption {
      default = "";
      type = types.nonEmptyStr;
      example = "codellama:13b";
      description = ''
        Specify model to run in ollama
      '';
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      services.ollama = {
        enable = true;
        acceleration = "cuda";
        home = "/var/lib/ollama";
      };
      #models are stored here
      environment.persistence."/persist".directories = [
        "/var/lib/private/ollama"
      ];

      systemd.services.ollama = {
        serviceConfig = {
          #IPAddressAllow = "localhost";
          #IPAddressDeny = "any";
          #SocketBindDeny = "any";
          SocketBindAllow = "tcp:11434";
        };
      };
    }
    (mkIf cfg.onlyOnAc {
      systemd.services.ollama = {
        unitConfig.ConditionACPower = true;
      };

      services.udev.extraRules = let
        base = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply"'';
        unplug = ''${base}, ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop ollama.service"'';
        plug = ''${base}, ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ollama.service"'';
      in
        strings.concatLines [unplug plug];

      # Do not start on boot
      systemd.services.ollama.wantedBy = mkForce [];
    })
    (mkIf cfg.ollamaEnableHyprlandKey {
      home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
        bind = ["$mainMod, z, exec,systemctl is-active ollama.service && foot -e ollama run ${cfg.ollamaModelHyprlandKey}"];
      };
    })
  ]);
}
