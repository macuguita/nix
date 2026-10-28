{ config, lib, ... }:
let
  inherit (lib.strings) hasPrefix;

  # Collect every module registered under a namespace, without forcing the
  # values (lib.filterAttrs would force them and cause recursion here).
  valuesUnder =
    set: prefix:
    map (name: set.${name}) (builtins.filter (name: hasPrefix prefix name) (builtins.attrNames set));

  nixosAll = {
    imports = valuesUnder config.dendritic.nixosModules "nixos/";
  };

  darwinAll = {
    imports = valuesUnder config.dendritic.darwinModules "darwin/";
  };
in
{
  # Expose the leaves plus an `all` aggregate. The aggregate lives in the flake
  # output set, not in `dendritic.*Modules`, so it never imports itself.
  config.flake.nixosModules = config.dendritic.nixosModules // {
    all = nixosAll;
  };

  config.flake.darwinModules = config.dendritic.darwinModules // {
    all = darwinAll;
  };
}
