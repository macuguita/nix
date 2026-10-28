{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/packages" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin system;
      inherit (lib.lists) optionals;

      pkgs-raddebugger = import inputs.nixpkgs-raddebugger { inherit system; };
    in
    {
      # Packages that don't need their own configuration module. Anything that
      # does (Emacs, vesktop, Ghostty, …) lives in a sibling file instead.
      packages =
        with pkgs;
        [
          inputs.helium.packages.${system}.default

          (pandora-launcher.override {
            jdks = [
              jdk8
              jdk17
              jdk21
              jdk25
            ];
          })
          (prismlauncher.override {
            jdks = [
              jdk8
              jdk17
              jdk21
              jdk25
            ];
          })

          mpv
          audacity
          blockbench
          aseprite
          qbittorrent

          pw-gui
          vineflower
          mcaselector

          python3
          rlwrap
        ]
        ++ optionals isLinux [
          filezilla
          krita
          renderdoc
          wineWow64Packages.waylandFull
          zenity
          seahorse
          mupdf
          inputs.pluey.packages.${system}.pluey
          inputs.bedrock-on-linux.packages.${system}.default
          inputs.kopuz.packages.${system}.default
          onlyoffice-desktopeditors
          kdePackages.kdenlive
          blender
          pkgs-raddebugger.raddebugger

          picard
          ryubing-canary
        ]
        ++ optionals isDarwin [
          caffeine
          shottr
          whatsapp-for-mac
          whisky
        ];
    };
}
