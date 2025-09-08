{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myHome.neovim;
in
{
  options.myHome.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable neovim.";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim;
    };
  };
}

