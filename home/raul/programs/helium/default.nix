{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nur.repos.lonerOrz.helium
  ];
}
