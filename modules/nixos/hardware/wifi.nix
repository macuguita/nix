{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/wifi" =
    { ... }:
    {
      hardware.wirelessRegulatoryDatabase = true;

      networking = {
        networkmanager = {
          enable = true;

          wifi = {
            backend = "iwd";
            powersave = true;
          };
        };
      };
    };
}
