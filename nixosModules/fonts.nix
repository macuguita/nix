{ config, lib, pkgs, ... }:

with lib;

let
  allFonts = {
    noto = pkgs.nerd-fonts.noto;
    "maple-mono" = pkgs.maple-mono.NL-NF-unhinted;
  };

  defaultFontAttrs = builtins.mapAttrs (_: _: true) allFonts;
in
{
  options.myNixos.fonts = {
    enableAll = mkOption {
      type = types.bool;
      default = true;
      description = "Enable all fonts";
    };

    fonts = mkOption {
      type = types.attrsOf types.bool;
      default = defaultFontAttrs;
      description = "Enable/disable individual fonts";
    };
  };

  config = let
    cfg = config.myNixos.fonts;
  in mkIf cfg.enableAll {
    fonts.packages = builtins.filter (x: x != null) (builtins.attrValues (
      builtins.mapAttrs (_name: enabled: if enabled then allFonts.${_name} else null)
        cfg.fonts
    ));
  };
}
