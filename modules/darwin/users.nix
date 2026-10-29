{ inputs, ... }:
{
  dendritic.darwinModules."darwin/users" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) mapAttrsToList;
      inherit (lib.strings) concatStringsSep escapeShellArg;

      toEnv =
        value: if builtins.isList value then concatStringsSep ":" (map toString value) else toString value;

      # Home-manager used to export these for GUI apps through launchd. Hjem
      # only produces a shell script, so publish the same variables to launchd.
      environmentScript = pkgs.writeShellScript "hjem-user-environment" ''
        set -euo pipefail

        ${concatStringsSep "\n" (
          mapAttrsToList (
            name: value: "/bin/launchctl setenv ${escapeShellArg name} ${escapeShellArg (toEnv value)}"
          ) config.hjem.users.raul.environment.sessionVariables
        )}
      '';

      # A real Applications tree containing only the .app bundles from the
      # user's packages. We copy from this instead of symlinking individual
      # bundles, because macOS Spotlight/LaunchServices do not index symlinked
      # app bundles reliably.
      applications = pkgs.buildEnv {
        name = "nix-user-applications";
        paths = config.hjem.users.raul.packages;
        pathsToLink = [ "/Applications" ];
      };

      # Same rsync flags Home Manager's targets.darwin.copyApps uses.
      copyAppsScript = pkgs.writeShellScript "copy-nix-apps" ''
        set -euo pipefail

        dest="$HOME/Applications/Nix User Apps"
        mkdir -p "$dest"

        # Migrate away from hjem's old symlinked bundles.
        ${pkgs.findutils}/bin/find "$dest" -maxdepth 1 -type l -name '*.app' -delete

        ${pkgs.rsync}/bin/rsync \
          --recursive \
          --checksum \
          --perms \
          --links \
          --copy-unsafe-links \
          --specials \
          --delete \
          --chmod=+w \
          ${applications}/Applications/ "$dest"
      '';
    in
    {
      imports = [ inputs.hjem.darwinModules.default ];

      hjem.clobberByDefault = true;
      hjem.users.raul = { };

      users.users.raul = {
        home = "/Users/raul";
        shell = pkgs.zsh;
      };

      system.primaryUser = "raul";

      # Hjem's link-nix-apps agent scans /etc/profiles/per-user/$USER for
      # Applications/*.app. nix-darwin only links /bin and /share/locale by
      # default, so without this .app bundles never reach the user profile.
      environment.pathsToLink = [ "/Applications" ];

      # Replace hjem's symlink-based app linker with the copy behavior Home
      # Manager used, so Spotlight and LaunchServices see real app bundles.
      launchd.user.agents.link-nix-apps.serviceConfig.Program = lib.mkForce "${copyAppsScript}";

      launchd.user.envVariables = config.hjem.users.raul.environment.sessionVariables;
      launchd.user.agents.user-environment.serviceConfig = {
        RunAtLoad = true;
        ProgramArguments = [ "${environmentScript}" ];
      };
    };
}
