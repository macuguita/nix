{ inputs, ... }:
let
  module =
    { ... }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowBroken = false;
        };
      };
    };
in
{
  dendritic.nixosModules."nixos/common/nixpkgs" = module;
  dendritic.darwinModules."darwin/common/nixpkgs" = module;
}
