{ inputs, ... }:
{
  dendritic.nixosModules."nixos/graphical" =
    { pkgs, lib, ... }:
    {
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
        vulkan-tools-lunarg
      ];

      qt.enable = true;

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

      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    };
}
