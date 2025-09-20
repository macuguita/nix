{ pkgs, ... }:

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

  home.packages = with pkgs; [
    btop
  ];

  home.stateVersion = "25.05";
}
