{ lib }: final: prev:
let
  broken_pkgs = {
    # add all broken packages here
    inherit (prev) trlib hpipm;
  };
in
lib.mapAttrs (n: pkg:
  pkg.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags or [] ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    ];
  })
) broken_pkgs
