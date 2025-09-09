{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.hyprland;
in
{
  options.myHome.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprland.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.hyprpaper
      pkgs.hyprlock
      pkgs.hyprpicker
      pkgs.hypridle
      pkgs.hyprsunset
      pkgs.hyprpolkitagent
      pkgs.hyprland-qt-support
      pkgs.dunst
      pkgs.libnotify
      pkgs.pywal16
      pkgs.waybar
      pkgs.woomer
    ];
  };
}
