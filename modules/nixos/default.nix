{ inputs, ... }:
{
  dendritic.nixosModules."nixos/nur" = {
    imports = [ inputs.nur.modules.nixos.default ];
  };
}
