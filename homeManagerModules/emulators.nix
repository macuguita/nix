
{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.emulators;
in
{
  options.myHome.emulators = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable emulators and its configs.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
        pkgs.ryubing
        pkgs.dolphin-emu
    ];
  };
}
