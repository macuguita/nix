{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {

    catppuccin.cursors = {
      enable = true;
      accent = "dark";
    };

    home.pointerCursor = {
      enable = true;
      size = 24;
      dotIcons.enable = false;
      gtk.enable = true;

      x11.enable = false;
    };

    home.packages = with pkgs; [
      wl-clipboard
      screenshot
      changeVolume
      record
      ddcutil
      hyprpicker
      nemo-with-extensions
    ];

    # Nemo stuff
    xdg.desktopEntries.nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };

    dconf = {
      settings = {
        "org/nemo/preferences" = {
          show-directories-first = false;
          show-hidden-files = true;
        };
        "org/cinnamon/desktop/default-applications/terminal" = {
          exec = "foot";
          exec-arg = "-e";
        };
      };
    };

    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications = lib.attrsets.genAttrs [
      "inode/directory"
      "application/x-gnome-saved-search"
    ] (f: "nemo.desktop");

    services.hyprpolkitagent.enable = true;
    services.kdeconnect.enable = true;

    # TODO: quickshell notis
    services.dunst.enable = true;

  };
}
