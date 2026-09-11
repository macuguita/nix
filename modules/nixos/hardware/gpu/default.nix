{ lib, config, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  imports = [
    ./amd.nix
    # https://youtu.be/MShbP3OpASA?t=2996
  ];

  config = mkIf (config.macuguita.hardware.gpu != null) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
