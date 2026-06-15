{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages =
      let
        ideaWithPlugins = inputs.nix-jetbrains-plugins.lib.buildIdeWithPlugins pkgs "idea" [
          "com.github.catppuccin.jetbrains"
          "com.github.catppuccin.jetbrains_icons"
          "com.demonwav.minecraft-dev"
          "GLSL"
        ];

        extraLibs = with pkgs; [
          libGL
          mesa
          libglvnd
          libdrm
          vulkan-loader
          flite
        ];
      in
      [
        (ideaWithPlugins.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/idea \
              --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLibs}"
          '';
        }))
      ];
  };
}
