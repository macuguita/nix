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
    helium.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable helium and its configs.";
    };
    minecraft.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Prism launcher and its configs.";
    };
  };

  imports = [
    #./lf/lf.nix
  ];

  config = {
    programs.firefox = mkIf cfg.firefox.enable {
      enable = true;
    };
    home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    } // (mkIf cfg.firefox.enable {
      BROWSER = "firefox";
    }) // (mkIf cfg.helium.enable {
      BROWSER = "helium";
    });

    home.packages = [
      pkgs.unzip
      pkgs.zip
    ]
    ++ lib.optionals cfg.minecraft.enable [
      pkgs.prismlauncher
      pkgs.jdk
      pkgs.glfw
    ] ++ lib.optionals cfg.helium.enable [
      pkgs.nur.repos.Ev357.helium
    ];
  };
}
