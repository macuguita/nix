{ lib, ... }:
{
  options.macuguita = {
    platform = lib.mkOption {
      description = "The platform this configuration targets.";
      type = lib.types.enum [
        "linux"
        "darwin"
      ];
    };

    localAi.enable = lib.mkEnableOption "Local AI";

    signingKey = lib.mkOption {
      description = "GPG key used to sign commits (git and jujutsu) on this system.";

      type = lib.types.strMatching "[0-9A-F]{16}";
    };

    hardware = {
      video = lib.mkEnableOption "Video" // {
        default = true;
      };

      audio = lib.mkEnableOption "Audio" // {
        default = true;
      };

      wifi = lib.mkEnableOption "Wi-Fi" // {
        default = true;
      };

      bluetooth = lib.mkEnableOption "Bluetooth" // {
        default = true;
      };

      battery = lib.mkEnableOption "Battery";

      touchpad = lib.mkEnableOption "Touchpad";

      qmk = lib.mkEnableOption "QMK";
      qmkKeychron = lib.mkEnableOption "QMK Keychron";

      cpu = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "amd"
            "intel"
          ]
        );

        default = null;
      };

      gpu = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "amd"
          ]
        );

        default = null;
      };
    };

    profiles = {
      graphical.enable = lib.mkEnableOption "Graphical";
      server.enable = lib.mkEnableOption "Server";
    };

    monitors = lib.mkOption {
      description = "The set of monitors expected to be plugged in.";

      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              width = lib.mkOption {
                type = lib.types.int;
              };

              height = lib.mkOption {
                type = lib.types.int;
              };

              primary = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };

              refreshRate = lib.mkOption {
                type = lib.types.float;
                default = 60.0;
              };

              offsetX = lib.mkOption {
                type = lib.types.int;
                default = 0;
              };

              offsetY = lib.mkOption {
                type = lib.types.int;
                default = 0;
              };

              scale = lib.mkOption {
                type = lib.types.float;
                default = 1.0;
              };
            };
          }
        )
      );
      default = { };
    };
  };
}
