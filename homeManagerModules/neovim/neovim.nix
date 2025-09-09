{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myHome.neovim;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.myHome.neovim = {
    enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable neovim.";
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable        = true;
      package       = pkgs.neovim;
      defaultEditor = true;
    };
    home.packages = [
      pkgs.neovide
      pkgs.libclang
      pkgs.lua-language-server
      pkgs.nil
    ];
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    xdg.configFile."nvim" = {
      source = createSymlink ./nvim;
      recursive = true;
    };
  };
}
