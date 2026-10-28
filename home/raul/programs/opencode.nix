{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/opencode" =
    { pkgs, ... }:
    {
      packages = [ pkgs.opencode ];

      xdg.config.files = {
        "opencode/cli.json" = {
          generator = (pkgs.formats.json { }).generate "opencode-cli.json";
          value = {
            theme = {
              name = "catppuccin";
              mode = "dark";
            };
          };
        };
      };
    };
}
