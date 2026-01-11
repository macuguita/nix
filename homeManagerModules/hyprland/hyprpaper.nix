{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.hyprpaper;
  wallpaper = ./../../hosts/pc-raul/wallpaper.jpg;
in
{
  options.myHome.hyprpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprpaper.";
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      wallpaper {
        monitor =
        path = ${wallpaper}
      }
      splash = false
    '';

    home.packages = [
      pkgs.hyprpaper
    ];
  };
}
