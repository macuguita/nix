{ config, inputs, ... }:
let
  hostModule =
    { ... }:
    {
      system.stateVersion = "26.05";
      networking.hostName = "pc-raul";

      hjem.specialArgs.signingKey = "DE0F62AEEC379198";

      hjem.users.raul.imports = [
        config.flake.homeModules.base
        config.flake.homeModules.desktop
        config.flake.homeModules.linux
        config.flake.homeModules.local-ai
      ];
    };
in
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.desktop
      config.flake.nixosModules.local-ai
      config.dendritic.nixosModules."hosts/desktop/hardware-configuration"
      config.dendritic.nixosModules."hosts/desktop/btrfs"
      hostModule
    ];
  };
}
