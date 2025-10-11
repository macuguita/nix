{ pkgs
, config
, lib
, ...
}: {
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;
    commands = {
      # for f in $fx; do
      #     xdg-open "$f" > /dev/null 2>&1 &
      # done ;;
      open = ''
        &{{
            case $(file --mime-type -bL -- "$f") in
                text/*|application/json)
                    $$EDITOR "$f" ;;
                image/*)
                    ${pkgs.imv}/bin/imv "$f" ;;
                audio/*)
                    ${pkgs.mpv}/bin/mpv "$f" ;;
                video/*)
                    ${pkgs.mpv}/bin/mpv --no-terminal "$f" ;;
                application/pdf|application/epub+zip)
                    ${pkgs.zathura}/bin/zathura "$f" ;;
                *)
                    $$EDITOR "$f" ;;
            esac
        }}
      '';
      drag-out = ''%${pkgs.ripdrag}/bin/ripdrag -a -x "$fx"'';
      editor-open = ''$$EDITOR "$f"'';
      edit-dir = ''$$EDITOR .'';

      #on-cd = ''
      #  ''${{ }}
      #'';
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

      # go to impermanence dir
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

    extraConfig =
      let
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.ctpv}/bin/ctpvclear
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        # set cleaner ''${pkgs.ctpv}/bin/ctpvclear
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${pkgs.ctpv}/bin/ctpv
        cmd stripspace %stripspace "$f"
        setlocal ~/Projects sortby time
        setlocal ~/Projects/* sortby time
        setlocal ~/Downloads/ sortby time
      '';
  };

  programs.zsh.initContent = lib.mkAfter ''
    lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        #./lfrun
        if [ -f "$tmp" ]; then
            dir="$(cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ]; then
                if [ "$dir" != "$(pwd)" ]; then
                    cd "$dir"
                fi
            fi
        fi
    }
    alias lf="lfcd"
  '';
}
