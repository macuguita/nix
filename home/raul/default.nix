{ ... }:
{
  imports = [
    ./direnv.nix
    ./nixpkgs.nix
    ./ollama.nix
    ./shell.nix
    ./wayland.nix
    ./hyprland
    ./style
    ./programs
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
    };
  };

  home.stateVersion = "26.05";
}
