{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    environment = {
      systemPackages = with pkgs; [
        wl-clipboard
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # Extra compositor to ease the hyprland -> niri transition; pick it from the
    # display manager like any other session. Hyprland stays available.
    programs.niri = {
      enable = true;
      # We use the GTK file chooser, not Nautilus.
      useNautilus = false;
    };

    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];

      # xdgOpenUsePortal = true;

      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };
}
