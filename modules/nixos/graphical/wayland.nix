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
