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

      launchd.user.envVariables = config.hjem.users.raul.environment.sessionVariables;
      launchd.user.agents.user-environment.serviceConfig = {
        RunAtLoad = true;
        ProgramArguments = [ "${environmentScript}" ];
      };
    };
}
