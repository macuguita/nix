{ inputs, ... }:
let
  module =
    { pkgs, ... }:
    {
      programs = {
        zsh.enable = true;

        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };

      environment.systemPackages = with pkgs; [
        wget
        curl

        killall
        file
        coreutils
        gnused
        rsync
        tree
        ripgrep
        fzf

        zip
        unzip
        zstd
        gnutar
        gzip
      ];
    };
in
{
  dendritic.nixosModules."nixos/common/shell" = module;
  dendritic.darwinModules."darwin/common/shell" = module;
}
