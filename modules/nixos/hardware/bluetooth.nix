{ config, lib, ... }:
{
  options.macuguita.hardware = {
    bluetooth = lib.mkEnableOption "Bluetooth" // {
      default = true;
    };
  };

  config = lib.mkIf config.macuguita.hardware.bluetooth {
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
