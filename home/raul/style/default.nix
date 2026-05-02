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

    enable = osConfig.macuguita.profiles.graphical.enable;
  };
}
