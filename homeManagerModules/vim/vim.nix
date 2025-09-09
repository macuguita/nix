{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myHome.vim;
  createSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  options.myHome.vim = {
    enable = mkOption {
      type        = types.bool;
      default     = true;
      description = "Enable vimrc.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vim
    ];
    home.file.".vimrc".source = createSymlink ./.vimrc;
  };
}
