{ inputs, ... }:
{
  dendritic.darwinModules."darwin/services" =
    { ... }:
    {
      services.tailscale.enable = true;
    };
}
