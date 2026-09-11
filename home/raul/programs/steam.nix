{ lib, osConfig, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf osConfig.macuguita.profiles.graphical.enable {
    xdg.configFile."autostart/steam.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Steam
      Exec=steam -silent
    '';
  };
}
