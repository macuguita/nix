{ lib, ... }:
let
  inherit (lib.options)
    mkOption
    mkEnableOption
    ;
  inherit (lib.types)
    enum
    strMatching
    nullOr
    attrsOf
    submodule
    int
    bool
    float
    ;
in
{
  options.macuguita = {
    platform = mkOption {
      description = "The platform this configuration targets.";
      type = enum [
        "linux"
        "darwin"
      ];
    };

    localAi.enable = mkEnableOption "Local AI";

    signingKey = mkOption {
      description = "GPG key used to sign commits (git and jujutsu) on this system.";

      type = strMatching "[0-9A-F]{16}";
    };

    hardware = {
      video = mkEnableOption "Video" // {
        default = true;
      };

      audio = mkEnableOption "Audio" // {
        default = true;
      };

      wifi = mkEnableOption "Wi-Fi" // {
        default = true;
      };

      bluetooth = mkEnableOption "Bluetooth" // {
        default = true;
      };

      battery = mkEnableOption "Battery";

      touchpad = mkEnableOption "Touchpad";

      qmk = mkEnableOption "QMK";
      qmkKeychron = mkEnableOption "QMK Keychron";

      cpu = mkOption {
        type = nullOr (enum [
          "amd"
          "intel"
        ]);

        default = null;
      };

      gpu = mkOption {
        type = nullOr (enum [
          "amd"
        ]);

        default = null;
      };
    };

    profiles = {
      graphical.enable = mkEnableOption "Graphical";
      server.enable = mkEnableOption "Server";
    };

    monitors = mkOption {
      description = "The set of monitors expected to be plugged in.";

      type = attrsOf (
        submodule (
          { ... }:
          {
            options = {
              width = mkOption {
                type = int;
              };

              height = mkOption {
                type = int;
              };

              primary = mkOption {
                type = bool;
                default = false;
              };

              refreshRate = mkOption {
                type = float;
                default = 60.0;
              };

              offsetX = mkOption {
                type = int;
                default = 0;
              };

              offsetY = mkOption {
                type = int;
                default = 0;
              };

              scale = mkOption {
                type = float;
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
