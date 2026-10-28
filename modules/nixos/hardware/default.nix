{ lib, config, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  imports = [
    ./cpu
    ./gpu
    ./ram.nix
    ./bluetooth.nix
    ./wifi.nix
    ./disc.nix
    ./laptop.nix
    ./qmk.nix
    ./audio.nix
  ];

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
}
