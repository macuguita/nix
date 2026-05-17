{ ... }:
{
  imports = [
    ./direnv.nix
    ./nixpkgs.nix
    ./shell.nix
    ./wayland.nix
    ./style
    ./programs
  ];

  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
  };

  home.stateVersion = "26.05";
}
