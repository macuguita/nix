{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.strings)
    makeLibraryPath
    optionalString
    ;
in
{
  config = mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages =
      let
        isLinux = pkgs.stdenv.hostPlatform.isLinux;
        isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

        extraLibs = optionals isLinux (
          with pkgs;
          [
            libpulseaudio
            glfw3-minecraft
            openal
            stdenv.cc.cc.lib
            libGL
            mesa
            libglvnd
            libdrm
            vulkan-loader
            flite
          ]
        );
      in
      [
        (
          (inputs.nix-jetbrains-plugins.lib.buildIdeWithPlugins pkgs "idea" [
            "com.demonwav.minecraft-dev"
            "dev.kikugie.stonecutter"
            "GLSL"
            "IdeaVIM"
          ]).overrideAttrs
          (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ optionals isLinux [ pkgs.makeWrapper ];

            # upstream `addPlugins` misses the darwin `open -na` launcher when
            # rewriting paths, tripping its own disallowedReferences check
            # (appending to buildPhase since it overrides the stdenv hooks)
            buildPhase =
              (old.buildPhase or "")
              + optionalString isDarwin ''
                substituteInPlace "$out/bin/idea" --replace-quiet '${old.src}' "$out"
              '';

            postFixup =
              (old.postFixup or "")
              + optionalString isLinux ''
                wrapProgram $out/bin/idea \
                  --prefix LD_LIBRARY_PATH : "${makeLibraryPath extraLibs}"
              '';
          })
        )
      ];
  };
}
