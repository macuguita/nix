{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/android" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-studio
        android-tools
      ];
    };
}
