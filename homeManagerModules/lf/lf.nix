{ pkgs, config, lib, ... }:
{
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;

    commands = {
      open = ''
        &{{
            case $(file --mime-type -bL -- "$f") in
                text/*|application/json)
                    lf -remote "send $id \$$EDITOR \$fx" ;;
                image/*)
                    ${lib.getExe pkgs.imv} "$fx" ;;
                audio/*)
                    ${lib.getExe pkgs.mpv} "$fx" ;;
                video/*)
                    ${lib.getExe pkgs.mpv} --no-terminal "$f" ;;
                application/pdf|application/epub+zip)
                    ${lib.getExe pkgs.zathura} "$f" ;;
                *)
                    lf -remote "send $id \$$EDITOR \$fx" ;;
            esac
        }}
      '';
      drag-out = ''%${pkgs.ripdrag}/bin/ripdrag -a -x "$fx"'';
      editor-open = ''$$EDITOR "$f"'';
      edit-dir = ''$$EDITOR .'';
    };

    keybindings = {
      "\\\"" = "";
      o = "";
      d = "";
      e = "";
      f = "";
      "." = "set hidden!";
      D = "delete";
      p = "paste";
      dd = "cut";
      y = "copy";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";
      a = "rename";
      r = "reload";
      C = "clear";
      U = "unselect";
      do = "drag-out";

      "g~" = "cd";
      gh = "cd";
      "g/" = "/";
      gd = "cd ~/Downloads";
      gt = "cd /tmp";
      gv = "cd ~/Videos";
      go = "cd ~/Documents";
      gc = "cd ~/.config";
      gn = "cd ~/nixconf";
      gp = "cd ~/Projects";
      gs = "cd ~/.local/share";
      gm = "cd /run/media";
      gH = "cd /persist/users/${config.home.homeDirectory}";

      ee = "editor-open";
      "e." = "edit-dir";
      V = ''''$${pkgs.bat}/bin/bat --paging=always --theme=gruvbox "$f"'';

      "<C-d>" = "5j";
      "<C-u>" = "5k";
    };

    settings = {
      reverse = true;
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            # Use Ghostty's support for the Kitty image protocol
            printf '\033_Ga=T,f=100,s=%dx%d,v=%dx%d;%s\033\\' "$w" "$h" "$x" "$y" "$(base64 < "$file")" > /dev/tty
            exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';

      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.ctpv}/bin/ctpvclear
        # Clear any displayed image (Kitty protocol works for Ghostty too)
        printf '\033_Ga=d\033\\' > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${pkgs.ctpv}/bin/ctpv
      cmd stripspace %stripspace "$f"
      setlocal ~/Projects sortby time
      setlocal ~/Projects/* sortby time
      setlocal ~/Downloads/ sortby time
    '';
  };

  # 🐚 Zsh-only integration
  programs.zsh.initExtra = lib.mkAfter ''
    lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
            dir="$(cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    }
    alias lf="lfcd"
  '';

  home.packages = [
    pkgs.lf
  ];
}

