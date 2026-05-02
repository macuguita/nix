{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  programs.vesktop = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    settings = {
      discordBranch = "canary";
      spellCheckLanguages = [
        "en-US"
        "en"
        "es-ES"
        "es"
      ];
      minimizeToTray = true;
      arRPC = true;
      hardwareAcceleration = false;
    };

    vencord = {
      themes = {
        font = ''
          :root {
            --font-code: monospace !important;
          }
        '';
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = "vesktop.desktop";
  };
}
