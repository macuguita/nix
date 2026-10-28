{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware" =
    { ... }:
    {
      services.fwupd.enable = true;

      hardware.enableRedistributableFirmware = true;
    };
}
