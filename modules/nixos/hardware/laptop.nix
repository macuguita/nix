{ lib, config, ... }:
{
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
