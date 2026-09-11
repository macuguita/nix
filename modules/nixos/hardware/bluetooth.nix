{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf config.macuguita.hardware.bluetooth {
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
