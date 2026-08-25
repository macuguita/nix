{ pkgs, lib, ... }:
{
  nix = {
    # fork of cppnix, many cool new features (also faster)
    package = pkgs.lixPackageSets.stable.lix;

    gc.automatic = true;
    channel.enable = false;

    settings = {
      connect-timeout = 50000;

      warn-dirty = false;

      auto-optimise-store = true;

      max-jobs = "auto";

      # ALWAYS ask before accepting a configuration
      accept-flake-config = false;

      # direnv stuff
      keep-derivations = true;
      keep-outputs = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        "cgroups"
        "auto-allocate-uids"
      ];

      substituters = [
        "https://nix-community.cachix.org"
        "https://vicinae.cachix.org"
        "https://catppuccin.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      ];

      use-xdg-base-directories = true;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      auto-allocate-uids = true;
      use-cgroups = true;
    };
  };
}
