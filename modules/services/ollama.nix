{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  inherit (lib) mkEnableOption types mkOption mkIf mkMerge strings;
  cfg = config.myOptions.services.ollama;
in {
  options.myOptions.services.ollama = {
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
      };
      systemd.services.ollama.serviceConfig = {
        IPAddressAllow = "localhost";
        IPAddressDeny = "any";
        SocketBindDeny = "any";
        SocketBindAllow = "tcp:11434";
      };
    }
    (mkIf cfg.onlyOnAc {
      systemd.services.ollama = {
        unitConfig.ConditionACPower = true;
      };

      services.udev.extraRules = let
        unplug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop ollama.service"'';
        plug = ''ACTION=="change", KERNEL=="AC0", SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start ollama.service"'';
      in
        strings.concatLines [unplug plug];
    })
    (mkIf cfg.ollamaEnableHyprlandKey {
      home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
        bind = ["$mainMod, z, exec,systemctl is-active ollama.service && foot -e ollama run ${cfg.ollamaModelHyprlandKey}"];
      };
    })
  ]);
}
