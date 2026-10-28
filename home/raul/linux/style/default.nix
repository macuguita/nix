{ inputs, ... }:
{
  dendritic.homeModules."home/raul/linux/style" =
    { osConfig, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        accent = "blue";
        flavor = "mocha";

        autoEnable = osConfig.macuguita.profiles.graphical.enable;
        enable = true;
      };
    };
}
