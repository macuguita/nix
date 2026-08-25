{
  osConfig,
  inputs,
  lib,
  system,
  pkgs,
  ...
}:
let
  isLinux = lib.strings.hasSuffix "-linux" system;
in
{
  imports = [
    ./helium
    ./emacs
    ./jetbrains.nix
    ./terminal.nix
    ./vicinae.nix
    ./vscode.nix
  ]
  ++ lib.optionals isLinux [
    ./quickshell
    ./emulators.nix
    ./discord.nix
  ];

  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages =
      with pkgs;
      [
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

        inputs.pluey.packages.${stdenv.hostPlatform.system}.pluey
        mupdf

        python3

        qbittorrent
      ]
      ++ lib.optionals isLinux [
        # not available on darwin
        filezilla
        aseprite
        krita

        pavucontrol
        pw-gui
        vineflower
        mcaselector

        renderdoc

        zenity

        wineWow64Packages.waylandFull

        onlyoffice-desktopeditors
        kdePackages.kdenlive
        blender
      ];
  };
}
