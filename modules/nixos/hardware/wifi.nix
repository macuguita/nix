{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf config.macuguita.hardware.wifi {
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
