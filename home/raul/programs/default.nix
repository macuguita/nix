{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs" =
    {
      osConfig,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.lists) optionals;
      inherit (lib.modules) mkIf;

      isLinux = pkgs.stdenv.hostPlatform.isLinux;
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      pkgs-raddebugger = import inputs.nixpkgs-raddebugger {
        system = pkgs.stdenv.hostPlatform.system;
      };
    in
    {
      config = mkIf osConfig.macuguita.profiles.graphical.enable {
        home.packages =
          with pkgs;
          [
            (pandora-launcher.override {
              jdks = [
                jdk8
                jdk17
                jdk21
                jdk25
              ];
            })
            (pkgs.prismlauncher.override {
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
            # not available on darwin
            filezilla
            krita
            pavucontrol

            renderdoc
            wineWow64Packages.waylandFull

            zenity
            seahorse

            mupdf
            inputs.pluey.packages.${stdenv.hostPlatform.system}.pluey
            inputs.bedrock-on-linux.packages.${stdenv.hostPlatform.system}.default
            onlyoffice-desktopeditors
            kdePackages.kdenlive
            blender
            pkgs-raddebugger.raddebugger
          ]
          ++ optionals isDarwin [
            caffeine
            shottr

            whatsapp-for-mac
            whisky
          ];
      };
    };
}
