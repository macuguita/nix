{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../../home
  ];

  users.users.raul = {
    home = "/Users/raul";
    shell = pkgs.zsh;
  };

  system.primaryUser = "raul";
}
