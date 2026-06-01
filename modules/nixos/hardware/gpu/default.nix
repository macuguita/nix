{ lib, config, ... }:
{
  imports = [
    ./amd.nix
    # https://youtu.be/MShbP3OpASA?t=2996
  ];

  options.macuguita.hardware.gpu = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "amd"
      ]
    );

    default = null;
  };

  config = lib.mkIf (config.macuguita.hardware.gpu != null) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
