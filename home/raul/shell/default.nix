{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
{
  home.shellAliases = {
    cat = "bat";
    grep = "grep --color=auto";
    mv = "mv -i";
    rm = "rm -Iv";
    vi = "vim";
    ls = "ls -h --color=auto";
    la = "ls -lah --color=auto --group-directories-first";
    wget = "wget --hsts-file=${config.xdg.cacheHome}/wget-hsts";
  };

  home.packages =
    with pkgs;
    [
      jq
      ffmpeg-full
      yt-dlp
      vim
      btop
      ripgrep
    ]
    ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      brightnessctl
    ])
    ++ (lib.optionals (pkgs.stdenv.hostPlatform.isLinux && osConfig.macuguita.hardware.battery) [
      pkgs.acpi
    ]);

  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      autocd = true;
      setOptions = [
        "AUTO_MENU"
        "MENU_COMPLETE"
        "AUTO_PARAM_SLASH"
        "GLOBDOTS"
        "INTERACTIVE_COMMENTS"
        "NO_CASE_GLOB"
        "NO_CASE_MATCH"
        "NO_EXTENDED_GLOB"
      ];
      history = {
        size = 1000000;
        save = 1000000;
        path = "${config.xdg.cacheHome}/zsh_history";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initContent = builtins.readFile ./zsh-init.zsh;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-your-shell.enable = true;

    jujutsu = {
      enable = true;

      settings = {
        user = {
          name = "macuguita";
          email = "me@macuguita.com";
        };
        signing = {
          behavior = "drop";
          backend = "gpg";
          key = osConfig.macuguita.signingKey;
        };
        git = {
          sign-on-push = true;
        };
        revset-aliases = {
          "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
        };
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "mac" = {
          hostname = "192.168.1.151";
          user = "raul";
          identityFile = [ "~/.sshKey/id_ed25519_mac" ];
        };

        "nix" = {
          hostname = "192.168.1.150";
          user = "raul";
          identityFile = [ "~/.sshKey/id_ed25519_nix" ];
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_personal" ];
        };

        "github.com-uni" = {
          hostname = "github.com";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_uni" ];
        };

        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_personal" ];
        };

        "tangled.org" = {
          hostname = "tangled.org";
          user = "git";
          identityFile = [ "~/.sshKey/id_ed25519_personal_tangled" ];
        };

        "opc" = {
          hostname = "158.179.210.199";
          user = "opc";
          identityFile = [ "~/.sshKey/opcKey" ];
        };
      };
    };

    git = {
      enable = true;

      signing = {
        key = osConfig.macuguita.signingKey;
        signByDefault = true;
      };

      settings = {
        user = {
          email = "me@macuguita.com";
          name = "macuguita";
        };
        core = {
          excludesFile = toString (
            pkgs.writeText "gitignore" ''
              .jj
              .env
              .DS_Store
            ''
          );
        };
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicprefix = true;
        };
        fetch.prune = true;
        push.autoSetupRemote = true;
        lfs.enable = true;

        init.defaultBranch = "main";
      };
    };

    bat.enable = true;
  };

  # fix ssh in fhs envs...
  home.file = {
    # home-manager wrongly thinks it doesn't manage (and thus shouldn't clobber) this file due to the activation script
    ".ssh/config".force = true;
  };

  home.activation = {
    # https://github.com/nix-community/home-manager/issues/322
    fixSshPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run install -d -m 0700 "$HOME/.ssh"
      if [ -L "$HOME/.ssh/config" ]; then
        src="$(readlink -f "$HOME/.ssh/config")"
        run rm -f "$HOME/.ssh/config"
        run install -m 0600 "$src" "$HOME/.ssh/config"
      fi
    '';
  };
}
