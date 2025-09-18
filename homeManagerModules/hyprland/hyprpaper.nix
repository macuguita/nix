{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.hyprpaper;
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
      preload = /etc/nixos/hosts/pc-raul/wallpaper.jpg
      wallpaper =, /etc/nixos/hosts/pc-raul/wallpaper.jpg
    '';

    home.packages = [
      pkgs.hyprpaper
    ];
  };
}
