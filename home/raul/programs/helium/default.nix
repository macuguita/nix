{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/helium" =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
