{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.catppuccin.darwinModules.catppuccin
    ./fonts.nix
  ];

  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    catppuccin = {
      cache.enable = true;

      accent = "blue";
      flavor = "mocha";

      autoEnable = true;
      enable = true;
    };

    environment.systemPackages = with pkgs; [
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
      mupdf

      # NOTE: aseprite/krita/filezilla don't build on aarch64-darwin
      inputs.pluey.packages.${stdenv.hostPlatform.system}.pluey

      qbittorrent

      python3

      gnupg
    ];
  };
}
