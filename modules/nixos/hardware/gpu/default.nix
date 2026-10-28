{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/gpu" =
    { lib, config, ... }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      config = mkIf (config.macuguita.hardware.gpu != null) {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
    };
}
