{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/steam" =
    { lib, pkgs, ... }:
    {
      xdg.config.files = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "autostart/steam.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=Steam
          Exec=steam -silent
        '';
      };
    };

  dendritic.nixosModules."nixos/programs/steam" =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
}
