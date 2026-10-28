{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/qmk" =
    { lib, config, ... }:
    {
      config = {
        hardware.keyboard.qmk = {
          enable = config.macuguita.hardware.qmk;
          keychronSupport = config.macuguita.hardware.qmk;
        };
      };
    };
}
