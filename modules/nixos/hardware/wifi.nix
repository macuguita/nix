{ config, lib, ... }:
{
  options.macuguita.hardware = {
    wifi = lib.mkEnableOption "Wi-Fi" // {
      default = true;
    };
  };

  config = lib.mkIf config.macuguita.hardware.wifi {
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
