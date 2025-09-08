{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHome.desktop;
in
{
  options.myHome.desktop = {
    firefox.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable firefox and its configs.";
    }
    darkMode.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dark mode wherever it is possible.";
    };
  };

  #TODO: add firefox extensions and configs
  config = mkIf cfg.firefox.enable {
    programs.firefox = {
      enable = true;
    };
  };

  config = mkIf cfg.darkMode.enable {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
    gtk = {
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
  };
}

