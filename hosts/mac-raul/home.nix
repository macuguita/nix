{ lib, pkgs, ... }:

{
  imports = [
    ./../../homeManagerModules/defaultDarwin.nix
  ];
  home.username = "raul";
  home.homeDirectory = "/Users/raul";

  myHome = {
    neovim.enable = true;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
