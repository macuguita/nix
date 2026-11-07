{ lib, ... }:
let
  inherit (lib.attrsets) genAttrs;
in
{
  eachSystem = genAttrs [
    "x86_64-linux"
    "aarch64-darwin"
  ];
}
