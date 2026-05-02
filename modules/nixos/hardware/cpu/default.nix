{ lib, ... }:
{
  imports = [
    ./amd.nix
    # ./intel.nix # i dont own any Intel cpus
  ];

  options.macuguita.hardware.cpu = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "amd"
        "intel"
      ]
    );

    default = null;
  };
}
