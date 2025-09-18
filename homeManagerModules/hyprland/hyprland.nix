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
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      monitor = "HDMI-A-1, 1920x1080@74.97Hz, 0x0, 1";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$browser" = "firefox";
      "$menu" = "rofi -show drun -show-icons";

      exec-once = [
        "dunst &"
        "hyprpaper &"
        "waybar &"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
        "col.inactive_border" = "rgba(${config.stylix.base16Scheme.base0}aa)";
        "col.active_border" = "rgba(${config.stylix.base16Scheme.base01}ee) rgba(${config.stylix.base16Scheme.base04}ee) rgba(${config.stylix.base16Scheme.base06}ee) 135deg";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 1;
        inactive_opacity = 1;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 2;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
            "global, 1, 10, default"
        ];
      };
    };
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
