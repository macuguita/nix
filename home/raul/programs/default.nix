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
  isDarwin = lib.strings.hasSuffix "-darwin" system;
  pkgs-pandora = import inputs.nixpkgs-pandora { inherit system; };
in
{
  imports = [
    ./helium
    ./emacs
    ./discord.nix
    ./jetbrains.nix
    ./terminal.nix
    ./vscode.nix
  ]
  ++ lib.optionals isLinux [
    ./vicinae.nix
    ./quickshell
    ./emulators.nix
  ];

  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages =
      with pkgs;
      [
        (pkgs-pandora.pandora-launcher.override {
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
        qbittorrent

        python3
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
        wineWow64Packages.waylandFull

        zenity
        seahorse

        mupdf
        inputs.pluey.packages.${stdenv.hostPlatform.system}.pluey
        onlyoffice-desktopeditors
        kdePackages.kdenlive
        blender
      ]
      ++ lib.optionals isDarwin [
        caffeine
        hidden-bar
        shottr

        whatsapp-for-mac
        whisky
      ];
  };
}
