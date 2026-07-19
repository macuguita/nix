{ pkgs, osConfig, ... }:
{
  home.packages =
    if osConfig.macuguita.profiles.graphical.enable then with pkgs; [ ryubing-canary ] else [ ];
}
