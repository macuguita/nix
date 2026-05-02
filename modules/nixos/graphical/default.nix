{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    ./wayland.nix
    ./greeter.nix
    ./fonts.nix
  ];

  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

    programs.dconf.enable = true;

    services = {
      libinput.enable = true;
      gpm.enable = true;
      udisks2.enable = true;
      printing.enable = true;
    };

    environment.systemPackages = with pkgs; [
      hunspell
      hunspellDicts.en_US
      hunspellDicts.es-es

      vulkan-tools
      vulkan-validation-layers
      vulkan-loader
    ];

    environment.sessionVariables = {
      LD_LIBRARY_PATH = map (pkg: "${pkg}/lib") (
        with pkgs;
        [
          # required for lwjgl games
          glfw
          libpulseaudio
          libGL
          openal
          stdenv.cc.cc

          udev # oshi

          libx11
          libxext
          libxcursor
          libxrandr
          libxxf86vm

          vulkan-tools
          vulkan-validation-layers
          vulkan-loader
        ]
      );
    };

    qt.enable = true;

    catppuccin = {
      cache.enable = true;

      accent = "blue";
      flavor = "mocha";

      enable = true;
    };

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v22n.psf.gz";
      keyMap = "us";
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        renderdoc
        libglvnd
        glfw
      ];
    };

    hardware.i2c.enable = true;

    # programs.kdeconnect.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };
}
