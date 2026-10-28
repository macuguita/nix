{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware" =
    { lib, config, ... }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      config = {
        services.fwupd.enable = true;

        hardware = {
          enableRedistributableFirmware = true;

          graphics = mkIf config.macuguita.hardware.video {
            enable = true;
            enable32Bit = true;
          };
        };
      };
    };
}
