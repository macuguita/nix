{ config, pkgs, ... }:

{
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
}

