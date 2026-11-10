{ ... }:
{
  dendritic.nixosModules."nixos/docker" = {
    virtualisation.docker.enable = true;
  };
}
