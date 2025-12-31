{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.wine;
in
{
  options.myHome.wine = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable wine and its configs.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wineWowPackages.stable
      pkgs.winetricks
    ];
    home.sessionVariables = {
      WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
    };
  };
}
