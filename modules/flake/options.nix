{ config, lib, ... }:
let
  moduleSet =
    description:
    lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
      inherit description;
    };
in
{
  options.dendritic = {
    # Leaf modules, keyed by their path in the flake tree. The wrappers under
    # modules/, home/ and hosts/ register into these sets, and the compositions
    # below read from them without referring to the attribute set that contains
    # the composition itself (which would recurse).
    nixosModules = moduleSet "NixOS modules registered by the flake tree.";
    darwinModules = moduleSet "nix-darwin modules registered by the flake tree.";
    homeModules = moduleSet "Hjem user modules registered by the flake tree.";
  };

  # flake-parts doesn't declare this output, so declare it ourselves to let the
  # leaf aggregate and the host-facing groups merge.
  options.flake.darwinModules = moduleSet "nix-darwin modules exposed by the flake.";

  # Home modules have no aggregate in `flake.homeModules`, so aliasing is safe.
  config.flake.homeModules = config.dendritic.homeModules;
}
