{ lib, pkgs, ... }:

let
  optimizeVideo = import ./../../homeManagerModules/scripts/optimizeVideo.nix { inherit pkgs; };
in
{
  imports = [
    ./../../homeManagerModules/defaultDarwin.nix
  ];
  home.username = "raul";
  home.homeDirectory = "/Users/raul";

  home.packages = [
    optimizeVideo
  ];

  myHome = {
    neovim.enable = true;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
