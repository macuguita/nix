{ inputs, ... }:
{
  dendritic.darwinModules."darwin/networking/ssh" =
    { ... }:
    {
      services.openssh.enable = true;
    };
}
