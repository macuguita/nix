{ pkgs, ... }:

let
  optimizeImage = import ./../../homeManagerModules/scripts/optimizeImage.nix { inherit pkgs; };
in
{
  imports = [
    ./../../homeManagerModules/defaultLinux.nix
  ];
  home.username = "raul";
  home.homeDirectory = "/home/raul";

  myHome = {
    neovim.enable = true;
    wine.enable = true;
  };

  home.packages = [
    optimizeImage
    pkgs.btop
  ];

  home.stateVersion = "25.05";
}
