{ pkgs, ... }:

pkgs.writeShellScriptBin "screenshot" ''
  SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
  FILENAME="screenshot_$(date +%d_%m_%Y_%H_%M_%S).png"
  OUTPUT="$SCREENSHOT_DIR/$FILENAME"

  fullscreen() {
      ${pkgs.grim}/bin/grim - | tee "$OUTPUT" | ${pkgs.wl-clipboard}/bin/wl-copy
  }

  areaSelection() {
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | tee "$OUTPUT" | ${pkgs.wl-clipboard}/bin/wl-copy
  }

  case $1 in
      fullscreen) fullscreen;;
      area) areaSelection;;
      *) ${pkgs.dunst}/bin/dunstify -u critial "Forgot to provide arguments to $0 script" && exit 1;;
  esac

  [[ $? -eq 0 ]] && ${pkgs.dunst}/bin/dunstify "Screenshot saved to $FILENAME" || ${pkgs.dunst}/bin/dunstify -u critial "Failed to save screenshot"
''
