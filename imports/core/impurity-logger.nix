{
  config,
  lib,
  pkgs,
  ...
}: let
  mkTracer = name: target: exe:
    lib.getExe (pkgs.writeShellScriptBin name ''
      echo "$(ps -p $PPID | sed '1d') executed ${target}" |& ${config.systemd.package}/bin/systemd-cat --identifier=impurity >/dev/null 2>/dev/null
      exec -a "$0" '${exe}' "$@"
    '');
in {
  environment = {
    usrbinenv = mkTracer "env" "/usr/bin/env" "${pkgs.coreutils}/bin/env";
    binsh = mkTracer "sh" "/bin/sh" "${pkgs.bashInteractive}/bin/sh";
  };
}
