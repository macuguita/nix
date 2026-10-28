{ inputs, ... }:
{
  dendritic.homeModules."home/raul/linux/programs/emulators" =
    { pkgs, osConfig, ... }:
    {
      home.packages =
        if osConfig.macuguita.profiles.graphical.enable then with pkgs; [ ryubing-canary ] else [ ];
    };
}
