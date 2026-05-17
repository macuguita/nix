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

      renderdoc
      blockbench

      # keepassxc # i switched to bitwarden but there is a decent chance i missed stuff so this is still here
      # bitwarden-desktop

      aseprite # build failure (https://github.com/NixOS/nixpkgs/issues/475832), disabled for now

      zenity

      python3

      wineWow64Packages.waylandFull

      onlyoffice-desktopeditors
      krita
      blender
    ];
  };
}
