{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/qmk" =
    { ... }:
    {
      hardware.keyboard.qmk = {
        enable = true;
        keychronSupport = true;
      };
    };
}
