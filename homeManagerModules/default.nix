{ config, pkgs, lib, ... }:

{
  imports =
  [
  ./cursor.nix
  ./desktop.nix
  ./env.nix
  ./neovim.nix
  ./shell.nix
  ./ssh.nix
  ];
}
