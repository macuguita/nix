{ config
, lib
, pkgs
, ...
}:

with lib;

{
  options.myNixos.xdg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable some fixes for opening files in file managers";
    };
  };

  config = lib.mkIf config.myNixos.xdg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.kwallet
      ];
    };

    environment.etc."xdg/menus/applications.menu".source =
      "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  };
}
