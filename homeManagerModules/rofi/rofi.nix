{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.rofi;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.myHome.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rofi.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rofi
    ];
    xdg.configFile."rofi" = {
      source = createSymlink ./rofi;
      recursive = true;
    };
  };
}
