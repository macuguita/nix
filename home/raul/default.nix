{
  lib,
  pkgs,
  system,
  ...
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.strings) hasSuffix;

  # `pkgs` must not be used in `imports` (infinite recursion), so gate on the
  # plain `system` string threaded through from the flake instead.
  isLinux = system |> hasSuffix "-linux";
in
{
  imports = [
    ./direnv.nix
    ./nixpkgs.nix
    ./ollama.nix
    ./shell
    ./programs
  ]
  ++ optionals isLinux [
    ./wayland.nix
    ./niri
    ./style
  ];

  home = {
    username = "raul";
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/raul" else "/home/raul";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      setSessionVariables = pkgs.stdenv.hostPlatform.isLinux;
    };
    autostart.enable = true;
  };

  # copy .app bundles from home.packages into ~/Applications/Home Manager Apps
  targets.darwin.copyApps.enable = pkgs.stdenv.hostPlatform.isDarwin;

  home.stateVersion = "26.05";
}
