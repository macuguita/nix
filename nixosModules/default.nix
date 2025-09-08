{ config, pkgs, lib, ... }:

{
  imports =
  [
  ./flatpak.nix
  ./fonts.nix
  ./greetd.nix
  ./localization.nix
  ./samba.nix
  ./steam.nix
  ./xdgStuff.nix
  ];
}
