{ lib, config, ... }:
{
  options.macuguita.hardware = {
    qmk = lib.mkEnableOption "QMK";
    qmkKeychron = lib.mkEnableOption "QMK Keychron";
  };

  config = {
    hardware.keyboard.qmk = {
      enable = config.macuguita.hardware.qmk;
      keychronSupport = config.macuguita.hardware.qmk;
    };
  };
}
