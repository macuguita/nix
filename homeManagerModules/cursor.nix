{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myHome.cursor;
in
{
  options.myHome.cursor = {
    enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable custom cursor configuration.";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        name    = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size    = 20;
      };
    };

    home.pointerCursor = {
      gtk.enable   = true;
      # x11.enable = true; # uncomment if you want X11 cursor too
      name         = "Bibata-Modern-Classic";
      package      = pkgs.bibata-cursors;
      size         = 20;
    };
  };
}
