{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/gpu" =
    { ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
