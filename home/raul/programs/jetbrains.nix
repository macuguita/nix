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
          "com.demonwav.minecraft-dev"
          "dev.kikugie.stonecutter"
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
