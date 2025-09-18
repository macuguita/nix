{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.kde;
in
{
  options.myHome.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable kde apps and its configs.";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.kde.enable = true;
    home.packages = [
      pkgs.libsForQt5.qt5ct
      pkgs.kdePackages.qt6ct
      pkgs.kdePackages.dolphin
      pkgs.kdePackages.ark
      pkgs.kdePackages.kio
      pkgs.kdePackages.kio-admin
      pkgs.kdePackages.kio-extras
      pkgs.kdePackages.kio-fuse
      pkgs.kdePackages.kservice
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwallet-pam
      pkgs.kdePackages.baloo
      pkgs.kdePackages.baloo-widgets
      pkgs.kdePackages.ffmpegthumbs
      pkgs.kdePackages.gwenview
      pkgs.kdePackages.okular
    ];
  };
}
