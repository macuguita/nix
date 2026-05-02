{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    fonts = {
      fontconfig = {
        enable = true;
        antialias = true;

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
            "Cartograph CF"
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

        (pkgs.stdenvNoCC.mkDerivation {
          # https://github.com/redyf/font-flake/blob/6c3d87082541/flake.nix#L85-L93
          name = "CartographCF";
          # "you wouldn't download a font"
          src = pkgs.fetchgit {
            url = "https://github.com/g5becks/Cartograph.git";
            rev = "eecba04db96206933496a8b845f68c19decb3c64";
            sha256 = "P8cii7ez9bAE+c7tN+oWQy3/LQPFtGUmlwQsKevbl0M=";
          };
          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/fonts/opentype
            find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;

            runHook postInstall
          '';
        })
      ];
    };

    # onlyoffice has trouble with symlinks: https://github.com/ONLYOFFICE/DocumentServer/issues/1859
    system.userActivationScripts = {
      copy-fonts-local-share = {
        text = ''
          rm -rf ~/.local/share/fonts
          mkdir -p ~/.local/share/fonts
          cp ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/
          cp ${pkgs.vista-fonts}/share/fonts/truetype/* ~/.local/share/fonts/
          chmod 544 ~/.local/share/fonts
          chmod 444 ~/.local/share/fonts/*
        '';
      };
    };
  };
}
