{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.ghostty;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  extraConfig =
    if pkgs.stdenv.isLinux then
      ./linux
    else if pkgs.stdenv.isDarwin then
      ./macos
    else
      throw "OS not supported";
in
{
  options.myHome.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ghostty.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ghostty
    ];
    xdg.configFile = {
      "ghostty/config".source = createSymlink ./config;
      "ghostty/extra".source = createSymlink extraConfig;
    };
    home.file.".local/share/kservices5/ServiceMenus/ghostty_dolphin.desktop".source = ./ghostty_dolphin.desktop;
  };
}
