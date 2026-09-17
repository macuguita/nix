{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib.attrsets) mapAttrs' optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.strings)
    makeLibraryPath
    optionalString
    ;

  ltsJdks = with pkgs; {
    "openjdk-8" = jdk8;
    "openjdk-11" = jdk11;
    "openjdk-17" = jdk17;
    "openjdk-21" = jdk21;
    "openjdk-25" = jdk25;
  };

  mkJdkLinks =
    prefix:
    ltsJdks
    |> mapAttrs' (
      name: jdk: {
        name = "${prefix}/${name}";
        value = {
          source = jdk.passthru.home or (jdk.home or jdk);
        };
      }
    );
in
{
  config = mkIf osConfig.macuguita.profiles.graphical.enable {
    home.file =
      (mkJdkLinks ".jdks") // optionalAttrs pkgs.stdenv.hostPlatform.isDarwin (mkJdkLinks "Library/Java/JavaVirtualMachines");

    home.packages =
      let
        extraLibs = optionals pkgs.stdenv.hostPlatform.isLinux (
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
          ]).overrideAttrs
            (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.makeWrapper ];

              # upstream `addPlugins` misses the darwin `open -na` launcher when
              # rewriting paths, tripping its own disallowedReferences check
              # (appending to buildPhase since it overrides the stdenv hooks)
              buildPhase =
                (old.buildPhase or "")
                + optionalString pkgs.stdenv.hostPlatform.isDarwin ''
                  substituteInPlace "$out/bin/idea" --replace-quiet '${old.src}' "$out"
                '';

              postFixup =
                (old.postFixup or "")
                + optionalString pkgs.stdenv.hostPlatform.isLinux ''
                  wrapProgram $out/bin/idea \
                    --prefix LD_LIBRARY_PATH : "${makeLibraryPath extraLibs}"
                '';
            })
        )
      ];
  };
}
