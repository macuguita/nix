{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.cli;
in
{
  options.myHome.cli = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable cli utils.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ffmpeg
      pkgs.imagemagick
      pkgs.fastfetch
      pkgs.yt-dlp
    ]
    ++ lib.optional pkgs.stdenv.isLinux pkgs.pavucontrol;
  };
}
