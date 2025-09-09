{ config, lib, ... }:

with lib;

let
  cfg = config.myHome.ssh;
in
{
  options.myHome.ssh = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable ssh config.";
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_personal" ];
        };

        "github.com-uni" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_uni" ];
        };

        "opc" = {
          hostname = "158.179.210.199";
          user = "opc";
          identityFile = [ "~/.sshKey/opcKey" ];
        };
      };
    };
  };
}
