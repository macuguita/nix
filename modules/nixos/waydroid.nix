{ inputs, ... }:
{
  dendritic.nixosModules."nixos/waydroid" =
    { ... }:
    {
      virtualisation.waydroid.enable = true;
    };
}
