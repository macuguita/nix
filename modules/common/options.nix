{ lib, ... }:
{
  options.macuguita = {
    localAi.enable = lib.mkEnableOption "Local AI";

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
    };
  };
}
