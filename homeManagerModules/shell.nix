{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.myHome.shell;
in
{
  options.myHome.shell = {
    enable = mkOption {
      type        = types.bool;
      default     = true;
      description = "Enable shell config and aliases.";
    };

    enableAliases = mkOption {
      type        = types.bool;
      default     = true;
      description = "Enable shell aliases.";
    };

    enableZsh = mkOption {
      type        = types.bool;
      default     = true;
      description = "Enable zsh config.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.fzf
      pkgs.bat
    ];

    home.shellAliases = mkIf cfg.enableAliases {
      cat     = "bat";
      grep    = "grep --color=auto";
      mv      = "mv -i";
      rm      = "rm -Iv";
      n       = "nvim";
      p       = "ps aux | grep $1";
      ls      = "ls -h --color=auto --group-directories-first";
      la      = "ls -lah --color=auto --group-directories-first";
      wget    = "wget --hsts-file=${config.xdg.cacheHome}/wget-hsts";
      rebuild = "sudo nixos-rebuild switch $@";
    };

    programs.zsh = mkIf cfg.enableZsh {
      enable = true;

      history = {
        size = 1000000;
        save = 1000000;
        path = "${config.xdg.cacheHome}/zsh_history";
      };

      initContent = ''
                [ -f "$XDG_CONFIG_HOME/shell/tokens" ] && source "$XDG_CONFIG_HOME/shell/tokens"

                # Zsh modules
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
                setopt extended_glob
                setopt interactive_comments
                unsetopt prompt_cr
                setopt prompt_sp
                unsetopt prompt_sp
                stty stop undef
                bindkey "^[[3~" delete-char

                # fzf setup
                source <(fzf --zsh)

                NEWLINE=$'\n'
                PROMPT="''${NEWLINE}%K{#2E3440}%F{#E5E9F0} $(date +%I:%M%p | tr '[:upper:]' '[:lower:]') %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ''${NEWLINE} ❯ "

                [ "$(uname)" = "Linux" ] && echo -e "''${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\033[48;2;59;66;82;38;2;216;222;233m $(awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if(d>0) printf "%d days ",d; if(h>0) printf "%d hours ",h; if(m>0) printf "%d minutes",m; print ""}' /proc/uptime
        ) \033[0m\033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"
                [ "$(uname)" = "Darwin" ] && echo -e "''${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m\033[48;2;59;66;82;38;2;216;222;233m  \033[0m\033[48;2;76;86;106;38;2;216;222;233m Darwin$(uname -r) \033[0m"
      '';
    };

    programs.bash = {
      enable = true;

      historySize = 1000000;
      historyFile = "${config.xdg.cacheHome}/bash_history";

      initExtra = ''
        NEWLINE=$'\n'

        PS1="''${NEWLINE}\[\e[38;5;46;48;5;235m\] \[\e[0m\]\[\e[38;5;46;48;5;237m\] \u \[\e[0m\]\[\e[38;5;46;48;5;239m\] \w \[\e[0m\]''${NEWLINE}\[\e[38;5;46m\]  ❯ \[\e[0m\]"
        echo -e "''${NEWLINE}\e[38;5;46;48;5;235m Welcome to bash! \e[0m"

        # fzf setup
        source <(fzf --bash)
      '';
    };
  };
}
