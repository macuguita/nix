{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/gnome" =
    { pkgs, lib, ... }:
    {
      xdg.config.files = {
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
          gtk-font-name=Inter 11
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
        '';

        "gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
          gtk-font-name=Inter 11
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
        '';
      };

      files = {
        ".icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=Adwaita
        '';
      };

      environment.sessionVariables = {
        GTK_USE_PORTAL = "1";
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
      };

      packages = with pkgs; [
        adwaita-icon-theme
        inter
        wl-clipboard
        screenshot
        changeVolume
        record
        ddcutil
      ];
    };

  dendritic.nixosModules."nixos/graphical/gnome-dconf" =
    { lib, ... }:
    {
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              accent-color = "blue";
              color-scheme = "prefer-dark";
              cursor-theme = "Adwaita";
              cursor-size = lib.gvariant.mkInt32 24;
              font-name = "Inter 11";
            };
            "org/gnome/desktop/input-sources" = {
              sources = [
                (lib.gvariant.mkTuple [
                  "xkb"
                  "es"
                ])
              ];
              mru-sources = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
            };
            "org/gnome/shell/keybindings" = {
              screenshot = [ "<Shift><Super>3" ];
              show-screenshot-ui = [ "<Shift><Super>5" ];
              screenshot-window = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
              show-screen-recording-ui = lib.gvariant.mkEmptyArray (lib.gvariant.type.string);
            };
            "org/gnome/settings-daemon/plugins/media-keys" = {
              next = [ "AudioNext" ];
              play = [ "AudioPlay" ];
              previous = [ "AudioPrev" ];
              volume-down = [ "AudioLowerVolume" ];
              volume-mute = [ "AudioMute" ];
              volume-up = [ "AudioRaiseVolume" ];

              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
              ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
              name = "Terminal";
              command = "ghostty";
              binding = "<Control><Alt>t";
            };
            "org/gnome/shell" = {
              favorite-apps = [
                "helium.desktop"
                "nemo.desktop"
                "emacsclient.desktop"
                "com.mitchellh.ghostty.desktop"
                "vesktop.desktop"
              ];
            };
          };
        }
      ];
    };

  dendritic.nixosModules."nixos/graphical/gnome" =
    { pkgs, ... }:
    {
      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;

        # Minimal GNOME: keep the shell and disable the application suites.
        # https://wiki.nixos.org/wiki/GNOME#GNOME_desktop
        gnome = {
          core-apps.enable = false;
          core-developer-tools.enable = false;
          games.enable = false;
        };
      };

      environment = {
        gnome.excludePackages = with pkgs; [
          gnome-tour
          gnome-user-docs
        ];

        systemPackages = with pkgs; [
          wl-clipboard

          qadwaitadecorations
          qadwaitadecorations-qt6

          qgnomeplatform
          qgnomeplatform-qt6
        ];

        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
        };
      };
    };
}
