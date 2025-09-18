{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.dunst;
in
{
  options.myHome.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dunst.";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."dunst/dunstrc".text = ''
      # See dunst(5) for all configuration options

      [global]
          monitor = 0
          follow = none
          width = (250, 500)
          height = (0, 750)
          origin = top-right
          offset = (20, 20)
          padding = 5
          horizontal_padding = 5
          frame_width = 2
          frame_color = "#${config.lib.stylix.colors.base0D}" # Window border
          gap_size = 3
          font = Monospace 11
          format = "<b>%s</b>\n%b"
          corner_radius = 10

      [urgency_low]
          background = "#${config.lib.stylix.colors.base00}"  # Default background
          foreground = "#${config.lib.stylix.colors.base05}"  # Default text
          frame_color = "#${config.lib.stylix.colors.base03}" # Low urgency border
          timeout = 10
          default_icon = dialog-information
          progress_bar_completed = "#${config.lib.stylix.colors.base02}"
          progress_bar_incomplete = "#${config.lib.stylix.colors.base01}"

      [urgency_normal]
          background = "#${config.lib.stylix.colors.base00}"
          foreground = "#${config.lib.stylix.colors.base05}"
          frame_color = "#${config.lib.stylix.colors.base0D}" # Normal border
          timeout = 10
          override_pause_level = 30
          default_icon = dialog-information
          progress_bar_completed = "#${config.lib.stylix.colors.base02}"
          progress_bar_incomplete = "#${config.lib.stylix.colors.base01}"

      [urgency_critical]
          background = "#${config.lib.stylix.colors.base00}"
          foreground = "#${config.lib.stylix.colors.base05}"
          frame_color = "#${config.lib.stylix.colors.base08}" # High urgency border
          timeout = 0
          override_pause_level = 60
          default_icon = dialog-warning
          progress_bar_completed = "#${config.lib.stylix.colors.base02}"
          progress_bar_incomplete = "#${config.lib.stylix.colors.base01}"
    '';

    home.packages = [
      pkgs.libnotify
      pkgs.dunst
    ];
  };
}

