{ config
, lib
, pkgs
, ...
}:

with lib;

{
  options.myNixos.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable greetd Hyprland auto-login";
    };
  };

  config = lib.mkIf config.myNixos.greetd.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.zsh}/bin/zsh -l -c Hyprland &> /dev/null";
          user = "raul";
        };
        default_session = initial_session;
      };
    };
  };
}
