{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  programs.vicinae = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    systemd = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      autoStart = true;
    };

    settings = {
      theme = {
        light = {
          name = lib.mkForce "catppuccin-latte";
          icon_theme = "default";
        };
        dark = {
          name = "catppuccin-mocha";
          icon_theme = "default";
        };
      };

      launcher_window = {
        opacity = 1.0;
      };
    };
  };
}
