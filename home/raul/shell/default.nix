{ inputs, ... }:
{
  dendritic.homeModules."home/raul/shell" =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux;
      inherit (lib.lists) optionals;
    in
    {
      packages =
        with pkgs;
        [
          jq
          ffmpeg-full
          yt-dlp
          vim
          btop
          ripgrep
          fzf
          nix-your-shell
          bat
          git
          jujutsu
          openssh
        ]
        ++ optionals isLinux [
          brightnessctl
        ];

      files = {
        ".zshrc".text = ''
          # Aliases
          alias cat="bat"
          alias grep="grep --color=auto"
          alias mv="mv -i"
          alias rm="rm -Iv"
          alias vi="vim"
          alias ls="ls -h --color=auto"
          alias la="ls -lah --color=auto --group-directories-first"
          alias wget="wget --hsts-file=$HOME/.cache/wget-hsts"

          # Options
          setopt AUTO_MENU MENU_COMPLETE AUTO_PARAM_SLASH GLOBDOTS INTERACTIVE_COMMENTS NO_CASE_GLOB NO_CASE_MATCH NO_EXTENDED_GLOB
          HISTSIZE=1000000
          SAVEHIST=1000000
          HISTFILE="$HOME/.cache/zsh_history"
          bindkey -e

          # Shell plugins
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          eval "$(${pkgs.fzf}/bin/fzf --zsh)"
          eval "$(${pkgs.nix-your-shell}/bin/nix-your-shell zsh)"
          eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

          # Extra zsh config
          ${builtins.readFile ./zsh-init.zsh}

          # Load Hjem session environment
          if [ -f "${config.environment.loadEnv}" ]; then
            source "${config.environment.loadEnv}"
          fi
        '';

        ".ssh/config".text = ''
          Host mac
            HostName 192.168.1.151
            User raul
            IdentityFile ~/.sshKey/id_ed25519_mac

          Host nix
            HostName 192.168.1.150
            User raul
            IdentityFile ~/.sshKey/id_ed25519_nix

          Host github.com
            HostName github.com
            User git
            IdentityFile ~/.sshKey/id_ed25519_personal

          Host github.com-uni
            HostName github.com
            User git
            IdentityFile ~/.sshKey/id_ed25519_uni

          Host codeberg.org
            HostName codeberg.org
            User git
            IdentityFile ~/.sshKey/id_ed25519_personal

          Host tangled.org
            HostName tangled.org
            User git
            IdentityFile ~/.sshKey/id_ed25519_personal_tangled

          Host opc
            HostName 158.179.210.199
            User opc
            IdentityFile ~/.sshKey/opcKey
        '';
      };
    };
}
