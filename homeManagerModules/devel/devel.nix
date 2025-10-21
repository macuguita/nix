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
      pkgs.direnv
      pkgs.vscodium
    ]
    ++ lib.optionals cfg.enableJetbrains [
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.webstorm
    ];

    programs.git = {
      enable = true;
      settings = {
        user.name = "macuguita";
        user.email = "raulpripri@gmail.com";

        user.signingkey = "${config.home.homeDirectory}/.sshKey/id_ed25519_personal";

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
