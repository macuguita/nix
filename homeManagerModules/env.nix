{ config, lib, ... }:

with lib;

let
  cfg = config.myHome.env;
in
{
  options.myHome.env = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable environment setup.";
    };
  };

  config = mkIf cfg.enable {
    xdg.configHome = "${config.home.homeDirectory}/.config";
    xdg.dataHome = "${config.home.homeDirectory}/.local/share";
    xdg.cacheHome = "${config.home.homeDirectory}/.cache";
    xdg.stateHome = "${config.home.homeDirectory}/.local/state";

    home.sessionVariables = {
      # EDITOR  = "nvim";
      TERM = "xterm-256color";
      # BROWSER = "helium";

      macuguita = "true";

      LESSHISTFILE = "${config.xdg.cacheHome}/less_history";

      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    };
  };
}
