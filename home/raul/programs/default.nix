{
  osConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # ./firefox
    ./helium
    ./quickshell
    ./emacs
    ./emulators.nix
    ./discord.nix
    ./jetbrains.nix
    # ./android.nix # no more android classes
    ./terminal.nix
    ./vicinae.nix
    ./vscode.nix
  ];

  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    home.packages = with pkgs; [
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
      pavucontrol
      pw-gui
      vineflower
      mcaselector

      filezilla

      renderdoc
      blockbench

      aseprite
      inputs.pluey.packages.${stdenv.hostPlatform.system}.pluey
      mupdf

      zenity

      python3

      wineWow64Packages.waylandFull

      onlyoffice-desktopeditors
      krita
      kdePackages.kdenlive
      blender
      qbittorrent
    ];
  };
}
