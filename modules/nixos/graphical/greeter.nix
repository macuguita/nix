{ inputs, ... }:
{
  dendritic.nixosModules."nixos/graphical/greeter" =
    { pkgs, config, ... }:
    {
      services.displayManager.ly.enable = true;
    };
}
