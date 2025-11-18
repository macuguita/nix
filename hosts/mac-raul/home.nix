{ lib, pkgs, ... }:

let
  optimizeImage = import ./../../homeManagerModules/scripts/optimizeImage.nix { inherit pkgs; };
  optimizeVideo = import ./../../homeManagerModules/scripts/optimizeVideo.nix { inherit pkgs; };
in
{
  imports = [
    ./../../homeManagerModules/defaultDarwin.nix
  ];
  home.username = "raul";
  home.homeDirectory = "/Users/raul";

  home.packages = [
    optimizeImage
    optimizeVideo
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
