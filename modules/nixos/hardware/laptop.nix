{ lib, config, ... }:
{
  options.macuguita.hardware = {
    battery = lib.mkEnableOption "Battery";
    touchpad = lib.mkEnableOption "Touchpad";
  };

  config = {
    services.upower = {
      enable = config.macuguita.hardware.battery;

      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;

      criticalPowerAction = "Hibernate";
    };
  };
}
