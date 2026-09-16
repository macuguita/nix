{
  osConfig,
  inputs,
  lib,
  system,
  pkgs,
  ...
}:
let
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;

  isLinux = system |> hasSuffix "-linux";
  isDarwin = system |> hasSuffix "-darwin";
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
  ++ optionals isLinux [
    ./vicinae.nix
    ./quickshell
    ./emulators.nix
    ./steam.nix
  ];

  config = mkIf osConfig.macuguita.profiles.graphical.enable {
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
        aseprite
        qbittorrent

        python3
      ]
      ++ optionals isLinux [
        # not available on darwin
        filezilla
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
        inputs.bedrock-on-linux.packages.${stdenv.hostPlatform.system}.default
        onlyoffice-desktopeditors
        kdePackages.kdenlive
        blender
      ]
      ++ optionals isDarwin [
        caffeine
        hidden-bar
        shottr

        whatsapp-for-mac
        whisky
      ];
  };
}
