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
    home.sessionVariables = {
      # EDITOR  = "nvim";
      TERM = "xterm-256color";
      # BROWSER = "firefox";

      macuguita = "true";

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";

      LESSHISTFILE = "$XDG_CACHE_HOME/less_history";

      # WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    };
  };
}
