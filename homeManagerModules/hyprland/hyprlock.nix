{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.hyprlock;
in
{
  options.myHome.hyprlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprlock.";
    };
  };

  config = mkIf cfg.enable {

    xdg.configFile."hypr/hyprlock.conf".text = ''
      $font = NotoSans Nerd Font

      input-field {
          monitor =
          size = 20%, 5%
          outline_thickness = 3
          inner_color = rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.5)

          outer_color = rgba(${config.lib.stylix.colors.base01-rgb-r}, ${config.lib.stylix.colors.base01-rgb-g}, ${config.lib.stylix.colors.base01-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base04-rgb-r}, ${config.lib.stylix.colors.base04-rgb-g}, ${config.lib.stylix.colors.base04-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base06-rgb-r}, ${config.lib.stylix.colors.base06-rgb-g}, ${config.lib.stylix.colors.base06-rgb-b}, 0.5) 135deg

          check_color = rgba(${config.lib.stylix.colors.base01-rgb-r}, ${config.lib.stylix.colors.base01-rgb-g}, ${config.lib.stylix.colors.base01-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base04-rgb-r}, ${config.lib.stylix.colors.base04-rgb-g}, ${config.lib.stylix.colors.base04-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base06-rgb-r}, ${config.lib.stylix.colors.base06-rgb-g}, ${config.lib.stylix.colors.base06-rgb-b}, 0.5) 135deg

          fail_color = rgba(${config.lib.stylix.colors.base00-rgb-r}, ${config.lib.stylix.colors.base00-rgb-g}, ${config.lib.stylix.colors.base00-rgb-b}, 0.75)

          font_color = rgba(${config.lib.stylix.colors.base05-rgb-r}, ${config.lib.stylix.colors.base05-rgb-g}, ${config.lib.stylix.colors.base05-rgb-b}, 0.75)
          fade_on_empty = false
          rounding = 15

          font_family = $font
          placeholder_text = Input password...
          fail_text = $PAMFAIL
          dots_spacing = 0.3

          position = 0, -120
          halign = center
          valign = center
      }

      image {
          monitor =
          path = $HOME/.config/hypr/images/user/$USER.png
          size = 150
          rounding = -1 # circle

          border_color = rgba(${config.lib.stylix.colors.base01-rgb-r}, ${config.lib.stylix.colors.base01-rgb-g}, ${config.lib.stylix.colors.base01-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base04-rgb-r}, ${config.lib.stylix.colors.base04-rgb-g}, ${config.lib.stylix.colors.base04-rgb-b}, 0.5) rgba(${config.lib.stylix.colors.base06-rgb-r}, ${config.lib.stylix.colors.base06-rgb-g}, ${config.lib.stylix.colors.base06-rgb-b}, 0.5) 135deg
          border_size = 4

          position = 0, 55
          halign = center
          valign = center
      }

      general {
          hide_cursor = false
      }

      animations {
          enabled = true
          bezier = linear, 1, 1, 0, 0
          animation = fadeIn, 1, 5, linear
          animation = fadeOut, 1, 5, linear
          animation = inputFieldDots, 1, 2, linear
      }

      background {
          monitor =
          path = ${config.stylix.image}
          blur_passes = 2
      }

      # TIME
      label {
          monitor =
          text = $TIME # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 75
          font_family = $font bold

          position = 0, -200
          halign = center
          valign = top
      }

      # DATE
      label {
          monitor =
          text = cmd[update:60000] date +"%A, %d %B %Y" # update every 60 seconds
          font_size = 20
          font_family = $font bold

          position = 0, -320
          halign = center
          valign = top
      }

      # USER
      label {
          monitor =
          text = $USER # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 25
          font_family = $font

          position = 0, -60
          halign = center
          valign = center
      }
    '';


    home.packages = [
      pkgs.hyprlock
    ];
  };
}
