{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    environment.variables.FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

    fonts = {
      fontconfig = {
        enable = true;
        antialias = true;

        hinting = {
          enable = true;
          style = "slight";
          autohint = false;
        };

        subpixel = {
          rgba = "none";
          lcdfilter = "default";
        };

        defaultFonts = {
          serif = [
            "Times New Roman"
            "Symbols Nerd Font"
          ];
          sansSerif = [
            "Inter"
            "Symbols Nerd Font"
          ];
          monospace = [
            "Maple Mono NL NF"
            "Symbols Nerd Font Mono"
          ];
        };
      };

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        twitter-color-emoji

        material-symbols

        nerd-fonts.symbols-only

        dejavu_fonts
        liberation_ttf

        # MS fonts
        corefonts
        vista-fonts

        inter

        maple-mono.NL-NF
      ];
    };

    # onlyoffice has trouble with symlinks: https://github.com/ONLYOFFICE/DocumentServer/issues/1859
    system.userActivationScripts = {
      copy-fonts-local-share = {
        text = ''
          mkdir -p ~/.local/share/fonts
          cp -f ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/
          cp -f ${pkgs.vista-fonts}/share/fonts/truetype/* ~/.local/share/fonts/
        '';
      };
    };
  };
}
