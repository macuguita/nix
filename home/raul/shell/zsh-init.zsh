# Extra zsh setup managed outside home-manager options.

zmodload zsh/complist
autoload -U colors && colors

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33
zstyle ':completion:*' squeeze-slashes false

stty stop undef
bindkey "^[[3~" delete-char

# Prompt handling: skip partial-line junk, no carriage return redraw
unsetopt prompt_cr
setopt prompt_sp

# search running processes
p() { ps aux | grep "$@" }

NEWLINE=$'\n'

# Dynamic prompt (updates every time)
precmd() {
  PROMPT="${NEWLINE}%K{#2E3440}%F{#E5E9F0} $(date +%I:%M%p | tr '[:upper:]' '[:lower:]') %K{#3b4252}%F{#ECEFF4} %n %K{#4c566a} %~ %f%k ${NEWLINE} ❯ "
}

# Startup banner (runs once)
if [ "$(uname)" = "Linux" ]; then
  uptime=$(awk '{d=int($1/86400); h=int(($1%86400)/3600); m=int(($1%3600)/60); if(d>0) printf "%d days ",d; if(h>0) printf "%d hours ",h; if(m>0) printf "%d minutes",m; print ""}' /proc/uptime)
  echo -e "${NEWLINE}\033[48;2;46;52;64;38;2;216;222;233m $0 \033[0m \033[48;2;59;66;82;38;2;216;222;233m $uptime \033[0m \033[48;2;76;86;106;38;2;216;222;233m $(uname -r) \033[0m"
fi
