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

      # TODO: remove when fixed
      (aseprite.overrideAttrs (old: {
        cmakeFlags = builtins.map
          (x:
            if x == "-DUSE_SHARED_FMT=ON"
            then "-DUSE_SHARED_FMT=OFF"
            else x)
          old.cmakeFlags;
      }))
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
