{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.vim;
in
{
  options.myHome.vim = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable vim.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.vim
      pkgs.gvim
      pkgs.ripgrep
      pkgs.fd
      pkgs.fzf
    ];
    home.file.".vimrc".source = ./.vimrc;
    home.file.".vim" = {
      recursive = true;
      source = ./.vim;
    };
  };
}
