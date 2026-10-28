{ config, ... }:
{
  # Expose the individual leaves alongside the host-facing groups from
  # groups.nix. There is intentionally no `all` aggregate anymore: hosts import
  # the groups they actually want.
  config.flake.nixosModules = config.dendritic.nixosModules;
  config.flake.darwinModules = config.dendritic.darwinModules;
}
