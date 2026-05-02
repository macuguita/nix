{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages = with inputs.nix-jetbrains-plugins.lib; [
      (buildIdeWithPlugins pkgs "idea" [
        "com.github.catppuccin.jetbrains"
        "com.github.catppuccin.jetbrains_icons"
        "com.demonwav.minecraft-dev"
        "GLSL"
      ])
    ];
  };
}
