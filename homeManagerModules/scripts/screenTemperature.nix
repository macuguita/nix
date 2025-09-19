{ pkgs, ... }:

pkgs.writeShellScriptBin "screenTemperature" ''
  BLUE_LIGHT_FILTER_TEMP=4750

  enable_filter() {
    ${pkgs.hyprland}/bin/hyprctl hyprsunset temperature "$BLUE_LIGHT_FILTER_TEMP" > /dev/null
    ${pkgs.dunst}/bin/dunstify "Enabled blue light night filter"
  }

  disable_filter() {
    ${pkgs.hyprland}/bin/hyprctl hyprsunset identity > /dev/null
    ${pkgs.dunst}/bin/dunstify "Disabled blue light night filter"
  }

  case $1 in
      enable) enable_filter;;
      disable) disable_filter;;
      *) ${pkgs.dunst}/bin/dunstify -u critial "Forgot to provide arguments to $0 script" && exit 1;;
  esac
''
