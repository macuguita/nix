{ lib, config, ... }:
{
  imports = [
    ./cpu
    ./gpu
    ./bluetooth.nix
    ./wifi.nix
    ./disc.nix
    ./laptop.nix
    ./qmk.nix
    ./audio.nix
  ];

  options.macuguita.hardware = {
    video = lib.mkEnableOption "Video" // {
      default = true;
    };
  };

  config = {
    services.fwupd.enable = true;

    hardware = {
      enableRedistributableFirmware = true;

      graphics = lib.mkIf config.macuguita.hardware.video {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
