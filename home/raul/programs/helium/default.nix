{
  lib,
  pkgs,
  ...
}:
{
  # helium (via NUR) does not build on darwin
  # Also replace with when done: https://github.com/NixOS/nixpkgs/pull/498572
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.nur.repos.lonerOrz.helium
  ];
}
