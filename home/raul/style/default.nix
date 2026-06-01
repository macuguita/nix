{ inputs, osConfig, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./gtk.nix
    ./qt.nix
  ];

  catppuccin = {
    accent = "blue";
    flavor = "mocha";

    autoEnable = osConfig.macuguita.profiles.graphical.enable;
    enable = true;
  };
}
