{ pkgs, config, ... }:

pkgs.writeShellScriptBin "colorPicker" ''
  FG_COLOR=${config.lib.stylix.colors.base05}
  FR_COLOR=${config.lib.stylix.colors.base0D}

  BG_COLOR=$(${pkgs.hyprpicker}/bin/hyprpicker | grep -oE '#[0-9A-Fa-f]{6}')

  ${pkgs.wl-clipboard}/bin/wl-copy "$BG_COLOR"

  ${pkgs.libnotify}/bin/notify-send \
      -u "normal" \
      -h "string:bgcolor:$BG_COLOR" \
      -h "string:fgcolor:$FG_COLOR" \
      -h "string:frcolor:$FR_COLOR" \
      "Copied $BG_COLOR to clipboard"
''
