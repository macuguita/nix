{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.macuguita.profiles.graphical.enable {
    fonts.packages = with pkgs; [
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
}
