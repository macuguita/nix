{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myHome.vesktop;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.myHome.vesktop = {
    enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable vesktop and its configuration.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vesktop
    ];
    xdg.configFile."vesktop/settings/settings.json" = {
      source = createSymlink ./settings.json;
    };
  };
}
