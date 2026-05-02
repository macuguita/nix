{ inputs, osConfig, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    systemd = {
      enable = true;
      autoStart = true;
    };

    settings = {
      theme = {
        light = {
          name = "catppuccin-latte";
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
