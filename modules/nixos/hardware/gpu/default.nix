{ lib, ... }:
{
  imports = [
    ./amd.nix
    # ./intel.nix
    # https://youtu.be/MShbP3OpASA?t=2996
  ];

  options.macuguita.hardware.gpu = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "amd"
        # "intel"
      ]
    );

    default = null;
  };
}
