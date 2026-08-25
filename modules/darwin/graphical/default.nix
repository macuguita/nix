{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.catppuccin.darwinModules.catppuccin
    ./fonts.nix
  ];

  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    catppuccin = {
      cache.enable = true;

      accent = "blue";
      flavor = "mocha";

      autoEnable = true;
      enable = true;
    };
  };
}
