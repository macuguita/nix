{ lib }: final: prev:
let
  broken_pkgs = {
    # add all broken packages here
    inherit (prev) filesystem;
  };
in
lib.mapAttrs (n: pkg:
  pkg.overrideAttrs (old: {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
      (lib.splitString " " (old.NIX_CFLAGS_COMPILE or "")) ++
      [ "-Wno-error=character-conversion" ]
    );
  })
) broken_pkgs

