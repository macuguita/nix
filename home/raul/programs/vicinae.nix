{
  inputs,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules)
    mkForce
    mkIf
    ;
in
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  programs.vicinae = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    # TODO: remove when it is fixed <https://github.com/vicinaehq/vicinae/issues/2040>
    package = pkgs.vicinae;

    systemd = mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      autoStart = true;
    };

    settings = {
      theme = {
        light = {
          name = mkForce "catppuccin-latte";
          icon_theme = "default";
        };
        dark = {
          name = "catppuccin-mocha";
          icon_theme = "default";
        };
      };

      launcher_window = {
        opacity = 1.0;
        layer_shell.layer = "overlay";
      };
    };
  };
}
