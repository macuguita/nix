{ inputs, ... }:
{
  dendritic.nixosModules."nixos/shell" =
    { pkgs, ... }:
    {
      users.defaultUserShell = pkgs.zsh;

      environment.systemPackages = with pkgs; [
        trash-cli
      ];

      programs = {
        git.enable = true;

        gnupg.agent.settings = {
          default-cache-ttl = 86400;
          max-cache-ttl = 604800;
        };

        bat = {
          enable = true;
          settings = {
            "style" = "plain";
          };
        };
      };
    };
}
