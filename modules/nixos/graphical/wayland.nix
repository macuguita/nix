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

    programs.niri = {
      enable = true;
      # We use the GTK file chooser, not Nautilus.
      useNautilus = false;
    };

    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;

      # The niri module adds xdg-desktop-portal-gnome for screencasts and sets
      # up the "niri" portal config; gtk remains as the generic fallback.
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      config.common.default = [ "gtk" ];
    };
  };
}
