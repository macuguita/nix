{ config, inputs, ... }:
let
  hostModule =
    { ... }:
    {
      macuguita = {
        platform = "darwin";

        signingKey = "40A199C6E6E4D710";

        localAi.enable = false;

        profiles = {
          graphical.enable = true;
        };
      };

      system.stateVersion = 6;
    };
in
{
  flake.darwinConfigurations.mac-raul = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      config.flake.darwinModules.all
      hostModule
    ];
  };
}
