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
  };
}
