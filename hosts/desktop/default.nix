{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  macuguita = {
    hardware = {
      cpu = "amd";
      gpu = "amd";

      bluetooth = true;
      wifi = false;
    };

    monitors = {
      HDMI-A-1 = {
        width = 1920;
        height = 1080;

        primary = true;

        refreshRate = 74.97300;
      };
    };

    profiles = {
      graphical.enable = true;
    };
  };

  system.stateVersion = "25.11";
  networking.hostName = "pc-raul";
}
