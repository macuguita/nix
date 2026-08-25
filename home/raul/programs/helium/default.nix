{
  lib,
  pkgs,
  ...
}:
{
  # helium (via NUR) does not build on darwin
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.nur.repos.lonerOrz.helium
  ];
}
