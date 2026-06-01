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
    ];

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
        libxcrypt
        libdrm
        libgbm
        udev
        libudev0-shim
        libva

        pipewire
        openal-soft

        glfw
        libGL
        vulkan-loader
        libx11
        libxcursor
        libxext
        libxrandr
        libxxf86vm

        renderdoc
      ];
    };

    hardware.i2c.enable = true;

    programs.kdeconnect.enable = true;

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
