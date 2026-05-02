{ pkgs, ... }:
{

  home.packages = with pkgs; [
    pkgs.nur.repos.Ev357.helium
  ];

}
