{ inputs, ... }:
{
  dendritic.darwinModules."darwin/graphical" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkIf;
    in
    {
      imports = [
        inputs.catppuccin.darwinModules.catppuccin
      ];

      config = mkIf config.macuguita.profiles.graphical.enable {
        nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

        catppuccin = {
          cache.enable = true;

          accent = "blue";
          flavor = "mocha";

          autoEnable = true;
          enable = true;
        };
      };
    };
}
