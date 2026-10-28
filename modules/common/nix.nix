{ inputs, ... }:
let
  module =
    { pkgs, lib, ... }:
    let
      inherit (lib.attrsets) optionalAttrs;
      inherit (lib.lists) optionals;
    in
    {
      nix = {
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
            "flakes"
            "nix-command"
            "pipe-operators"
            "cgroups"
            "auto-allocate-uids"
          ];

          substituters = [
            "https://nix-community.cachix.org"
          ];

          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          use-xdg-base-directories = true;
        }
        // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          auto-allocate-uids = true;
          use-cgroups = true;
        };
      };
    };
in
{
  dendritic.nixosModules."nixos/common/nix" = module;
  dendritic.darwinModules."darwin/common/nix" = module;
}
