{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.devel;
in
{
  options.myHome.devel = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable development stuff.";
    };
    enableJetbrains = mkOption {
      type = types.bool;
      default = false;
      description = "Enables jetbrains ides";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.git
      pkgs.gcc
      pkgs.cargo
      pkgs.jdk
    ]
    ++ lib.optional cfg.enableJetbrains pkgs.jetbrains.idea-community-bin;

    programs.git = {
      enable = true;

      userName = "macuguita";
      userEmail = "raulpripri@gmail.com";

      extraConfig = {
        user.signingkey = "~/.sshKey/id_ed25519_personal.pub";

        core = {
          excludesFile = "${toString ./gitignore}";
          autocrlf = "input";
        };

        init = {
          defaultBranch = "main";
        };

        aliases = {
          squash = "!sh -c 'git rebase -i HEAD~$0' -";
        };

        gpg.format = "ssh";

        safe = {
          directory = "/etc/nixos";
        };
      };
    };
  };
}
