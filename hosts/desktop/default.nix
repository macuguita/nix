{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./btrfs.nix
  ];

  macuguita = {
    platform = "linux";

    signingKey = "DE0F62AEEC379198";

    hardware = {
      cpu = "amd";
      gpu = "amd";

      bluetooth = true;
      qmk = true;
      qmkKeychron = true;
      wifi = false;
    };

    localAi.enable = true;

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

  system.stateVersion = "26.05";
  networking.hostName = "pc-raul";
}
