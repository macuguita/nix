{ config, lib, ... }:

with lib;

{
  options.myNixos.samba = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sharing the drive";
    };
  };

  config = lib.mkIf config.myNixos.samba.enable {
    services.samba = {
      enable = true;
      settings = {
        root = {
          path = "/";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "valid users" = "raul";
        };
      };
    };
  };
}
