{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.modules) mkIf;
in
{
  config = mkIf osConfig.macuguita.profiles.graphical.enable {

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

    xdg.mimeApps = {
      enable = true;

      defaultApplications =
        genAttrs [
          "inode/directory"
          "application/x-gnome-saved-search"
        ] (_: "nemo.desktop")
        // genAttrs [
          "image/jpeg"
          "image/png"
          "image/webp"
          "image/gif"
          "image/bmp"
          "image/tiff"
          "image/x-portable-pixmap"
          "image/x-portable-graymap"
          "image/x-portable-bitmap"
          "image/x-portable-anymap"
          "image/x-tga"
          "image/x-xbitmap"
          "image/x-xpixmap"
          "image/avif"
          "image/heic"
          "image/heif"
        ] (_: "com.macuguita.Pluey.desktop")
        // {
          "application/pdf" = "mupdf.desktop";
        };
    };

    # generic polkit auth agent (hyprpolkitagent only worked under Hyprland)
    systemd.user.services.polkit-gnome = {
      Unit = {
        Description = "polkit-gnome authentication agent";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    services.kdeconnect.enable = true;

    # TODO: quickshell notis
    services.dunst.enable = true;

  };
}
