{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.stylix;
in
{
  options.myHome.stylix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable stylix stuff cursor and fonts.";
    };
  };

  config = mkIf cfg.enable {
    stylix = {
      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 20;
      };
      fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.maple-mono.NL-NF-unhinted;
          name = "Maple Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };
  };
}
