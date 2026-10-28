{ config, lib, ... }:
let
  inherit (lib.strings) hasPrefix;

  isLinuxModule = name: hasPrefix "home/raul/linux/" name;
  isDarwinModule = name: hasPrefix "home/raul/darwin/" name;

  # Everything directly under home/raul is shared between platforms; the
  # linux/ and darwin/ subtrees are only pulled into the matching profile.
  #
  # Use attrNames + map instead of filterAttrs: the latter forces every value,
  # which would recurse while these aggregates are being defined.
  homeModules = builtins.attrNames config.dendritic.homeModules;

  pick = names: map (name: config.dendritic.homeModules.${name}) names;

  baseImports = pick (
    builtins.filter (
      name: hasPrefix "home/raul/" name && !(isLinuxModule name) && !(isDarwinModule name)
    ) homeModules
  );

  linuxImports = pick (builtins.filter isLinuxModule homeModules);
  darwinImports = pick (builtins.filter isDarwinModule homeModules);

  common =
    { pkgs, ... }:
    {
      imports = baseImports;

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

      # copy .app bundles from home.packages into ~/Applications/ Home Manager Apps
      targets.darwin.copyApps.enable = pkgs.stdenv.hostPlatform.isDarwin;

      home.stateVersion = "26.05";
    };
in
{
  dendritic.homeProfiles."raul-base" = common;

  dendritic.homeProfiles."raul-linux" = {
    imports = [ common ] ++ linuxImports;
  };

  dendritic.homeProfiles."raul-darwin" = {
    imports = [ common ] ++ darwinImports;
  };
}
