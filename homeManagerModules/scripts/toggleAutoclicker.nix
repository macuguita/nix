{ pkgs, ... }:

pkgs.writeShellScriptBin "toggleAutoclicker" ''
  PIDFILE="/tmp/autoclicker.pid"

  if [[ -f "$PIDFILE" && -e /proc/$(<"$PIDFILE") ]]; then
      kill "$(cat "$PIDFILE")" && rm "$PIDFILE"
  else
      (
          while true; do
              echo click left | ${pkgs.dotool}/bin/dotool
              sleep 0.05
          done
      ) &
      echo $! > "$PIDFILE"
  fi
''
