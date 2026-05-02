{ pkgs, osConfig, ... }:
let
  ryujinx-canary = pkgs.callPackage ./ryujinx-canary/package.nix { };
in
{
  home.packages =
    if osConfig.macuguita.profiles.graphical.enable then
      [ ryujinx-canary ]
    else
      [ ];
}
