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
    p = "ps aux | grep $1";
    ls = "ls -h --color=auto --group-directories-first";
    la = "ls -lah --color=auto --group-directories-first";
    wget = "wget --hsts-file=${config.xdg.cacheHome}/wget-hsts";
    rebuild = "doas nixos-rebuild switch --flake $HOME/nix#desktop";
  };

  home.packages =
    with pkgs;
    [
      brightnessctl
      jq
      ffmpeg-full
      yt-dlp
      vim
    ]
    ++ (lib.optionals osConfig.macuguita.hardware.battery [
      pkgs.acpi
    ]);

  programs = {
    zsh = {
      enable = true;
      history = {
        size = 1000000;
        save = 1000000;
        path = "${config.xdg.cacheHome}/zsh_history";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      initContent = ''
          zmodload zsh/complist
          autoload -U colors && colors

          # Completion options
          zstyle ':completion:*' menu select
          zstyle ':completion:*' special-dirs true
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} ma=0\;33
          zstyle ':completion:*' squeeze-slashes false

          # Main options
          bindkey -e
          setopt append_history inc_append_history share_history
          setopt auto_menu menu_complete
          setopt autocd
          setopt auto_param_slash
          setopt no_case_glob no_case_match
          setopt globdots
          setopt interactive_comments
          setopt no_extended_glob
          unsetopt prompt_cr
          setopt prompt_sp
          stty stop undef
          bindkey "^[[3~" delete-char

          # fzf setup
          source <(${pkgs.fzf}/bin/fzf --zsh)

          NEWLINE=$'\n'

          # Dynamic prompt (updates every time)
          precmd() {
            PROMPT="''${NEWLINE}%K{#2E3440}%F{#E5E9F0} $(date +%I:%M%p | tr '[:upper:]' '[:lower:]') %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ''${NEWLINE} ❯ "
          }

          # Startup banner (runs once)
          if [ "$(uname)" = "Linux" ]; then
            echo -e "''${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\
        \033[48;2;59;66;82;38;2;216;222;233m $(awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if(d>0) printf "%d days ",d; if(h>0) printf "%d hours ",h; if(m>0) printf "%d minutes",m; print ""}' /proc/uptime) \033[0m\
        \033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"
          fi
      '';
    };

    nix-your-shell.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
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
        key = "DCAA89416994E924";
        signByDefault = true;
      };

      settings = {
        user = {
          email = "me@macuguita.com";
          name = "macuguita";
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
}
