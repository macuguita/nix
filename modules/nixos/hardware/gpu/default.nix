{ lib, config, ... }:
{
  imports = [
    ./amd.nix
    # https://youtu.be/MShbP3OpASA?t=2996
  ];

  config = lib.mkIf (config.macuguita.hardware.gpu != null) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
