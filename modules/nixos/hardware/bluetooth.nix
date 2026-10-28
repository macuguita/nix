{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/bluetooth" =
    { ... }:
    {
      hardware.bluetooth = {
        enable = true;

        powerOnBoot = true;
        settings = {
          General.Experimental = true;
          Policy.AutoEnable = true;
        };
      };

      services.blueman.enable = true;
    };
}
