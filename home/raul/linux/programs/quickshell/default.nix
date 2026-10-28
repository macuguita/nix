{ inputs, ... }:
{
  dendritic.homeModules."home/raul/linux/programs/quickshell" =
    {
      config,
      ...
    }:
    {
      programs.quickshell = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile."quickshell" = {
        source = ./.;
      };
    };
}
