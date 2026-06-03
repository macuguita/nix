{
  osConfig,
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

      aseprite

      zenity

      python3

      wineWow64Packages.waylandFull

      onlyoffice-desktopeditors
      krita
      blender
    ];
  };
}
