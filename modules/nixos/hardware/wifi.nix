{ config, lib, ... }:
{
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
