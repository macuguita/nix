{ config
, lib
, pkgs
, ...
}:

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
    };
    minecraft.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Prism launcher and its configs.";
    };
    darkMode.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dark mode wherever it is possible.";
    };
  };

  config = {
    programs.firefox = mkIf cfg.firefox.enable {
      enable = true;
    };
    home.sessionVariables = mkIf cfg.firefox.enable {
      BROWSER = "firefox";
    };

    home.packages = [
    ]
    ++ lib.optionals cfg.minecraft.enable [
      pkgs.prismlauncher
      pkgs.jdk
      pkgs.glfw
    ];

    dconf.settings = mkIf cfg.darkMode.enable {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = mkIf cfg.darkMode.enable {
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
  };
}
