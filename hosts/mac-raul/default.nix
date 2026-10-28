{ config, inputs, ... }:
let
  hostModule =
    { ... }:
    {
      system.stateVersion = 6;

      hjem.specialArgs.signingKey = "40A199C6E6E4D710";

      hjem.users.raul.imports = [
        config.flake.homeModules.base
        config.flake.homeModules.desktop
      ];
    };
in
{
  flake.darwinConfigurations.mac-raul = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      config.flake.darwinModules.desktop
      hostModule
    ];
  };
}
