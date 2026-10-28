{ inputs, ... }:
{
  dendritic.darwinModules."darwin/nur" = {
    imports = [ inputs.nur.modules.darwin.default ];
  };
}
