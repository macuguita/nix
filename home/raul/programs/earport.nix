{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/earport" =
    {
      pkgs,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;

      daemon = inputs.earport.packages.${system}.earport-daemon;
      extension = inputs.earport.packages.${system}.earport-extension;

      extensionUuid = "earport@anoryth.github.io";
    in
    {
      packages = [
        daemon
        extension
      ];

      dconf.settings = {
        "org/gnome/shell" = {
          enabled-extensions = [ extensionUuid ];
        };
      };

      xdg.config.files."earport/daemon.conf" = {
        type = "copy";
        permissions = "0644";
        text = ''
          [Settings]
          ear_pause_mode=1
          auto_connect=false
          apple_handoff=false
        '';
      };

      systemd.services.earport-daemon = {
        description = "EarPort AirPods daemon";

        after = [ "bluetooth.target" ];
        wantedBy = [ "default.target" ];

        serviceConfig = {
          Type = "dbus";
          BusName = "io.github.anoryth.EarPort";
          ExecStart = "${daemon}/bin/earport-daemon";
          Restart = "on-failure";
          RestartSec = 5;

          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          PrivateTmp = true;

          ConfigurationDirectory = "earport";
          ConfigurationDirectoryMode = "0700";
        };
      };
    };
}
