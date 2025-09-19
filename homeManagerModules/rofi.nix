{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.rofi;
in
{
  options.myHome.rofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable rofi.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rofi
    ];

    xdg.configFile."rofi/config.rasi".text = ''
      configuration {
      /*  modes: "window,drun,run,ssh";*/
      /*  font: "mono 12";*/
      /*  location: 0;*/
      /*  yoffset: 0;*/
      /*  xoffset: 0;*/
      /*  fixed-num-lines: true;*/
      /*  show-icons: false;*/
      /*  preview-cmd: ;*/
      /*  on-selection-changed: ;*/
      /*  on-mode-changed: ;*/
      /*  on-entry-accepted: ;*/
      /*  on-menu-canceled: ;*/
      /*  on-menu-error: ;*/
      /*  on-screenshot-taken: ;*/
      /*  terminal: "rofi-sensible-terminal";*/
      /*  ssh-client: "ssh";*/
      /*  ssh-command: "{terminal} -e {ssh-client} {host} [-p {port}]";*/
      /*  run-command: "{cmd}";*/
      /*  run-list-command: "";*/
      /*  run-shell-command: "{terminal} -e {cmd}";*/
      /*  window-command: "wmctrl -i -R {window}";*/
      /*  window-match-fields: "all";*/
      /*  icon-theme: ;*/
      /*  drun-match-fields: "name,generic,exec,categories,keywords";*/
      /*  drun-categories: ;*/
      /*  drun-exclude-categories: ;*/
      /*  drun-show-actions: false;*/
      /*  drun-display-format: "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";*/
      /*  drun-url-launcher: "xdg-open";*/
      /*  disable-history: false;*/
      /*  ignored-prefixes: "";*/
      /*  sort: false;*/
      /*  sorting-method: "normal";*/
      /*  case-sensitive: false;*/
      /*  case-smart: false;*/
      /*  cycle: true;*/
      /*  sidebar-mode: false;*/
      /*  hover-select: false;*/
      /*  eh: 1;*/
      /*  auto-select: false;*/
      /*  parse-hosts: false;*/
      /*  parse-known-hosts: true;*/
      /*  combi-modes: "window,run";*/
      /*  matching: "normal";*/
      /*  tokenize: true;*/
      /*  m: "-5";*/
      /*  filter: ;*/
      /*  dpi: -1;*/
      /*  threads: 0;*/
      /*  scroll-method: 0;*/
      /*  window-format: "{w}    {c}   {t}";*/
      /*  click-to-exit: true;*/
      /*  max-history-size: 25;*/
      /*  combi-hide-mode-prefix: false;*/
      /*  combi-display-format: "{mode} {text}";*/
      /*  matching-negate-char: '-' /* unsupported */;*/
      /*  cache-dir: ;*/
      /*  window-thumbnail: false;*/
      /*  drun-use-desktop-cache: false;*/
      /*  drun-reload-desktop-cache: false;*/
      /*  normalize-match: false;*/
      /*  steal-focus: false;*/
      /*  application-fallback-icon: ;*/
      /*  refilter-timeout-limit: 300;*/
      /*  xserver-i300-workaround: false;*/
      /*  completer-mode: "filebrowser";*/
      /*  imdkit: true;*/
      /*  pid: "/run/user/1000/rofi.pid";*/
      /*  display-window: ;*/
      /*  display-windowcd: ;*/
      /*  display-run: ;*/
      /*  display-ssh: ;*/
      /*  display-drun: ;*/
      /*  display-combi: ;*/
      /*  display-keys: ;*/
      /*  display-filebrowser: ;*/
      /*  display-recursivebrowser: ;*/
      /*  kb-primary-paste: "Control+V,Shift+Insert";*/
      /*  kb-secondary-paste: "Control+v,Insert";*/
      /*  kb-secondary-copy: "Control+c";*/
      /*  kb-clear-line: "Control+w";*/
      /*  kb-move-front: "Control+a";*/
      /*  kb-move-end: "Control+e";*/
      /*  kb-move-word-back: "Alt+b,Control+Left";*/
      /*  kb-move-word-forward: "Alt+f,Control+Right";*/
      /*  kb-move-char-back: "Left,Control+b";*/
      /*  kb-move-char-forward: "Right,Control+f";*/
      /*  kb-remove-word-back: "Control+Alt+h,Control+BackSpace";*/
      /*  kb-remove-word-forward: "Control+Alt+d";*/
      /*  kb-remove-char-forward: "Delete,Control+d";*/
      /*  kb-remove-char-back: "BackSpace,Shift+BackSpace,Control+h";*/
      /*  kb-remove-to-eol: "Control+k";*/
      /*  kb-remove-to-sol: "Control+u";*/
      /*  kb-accept-entry: "Control+j,Control+m,Return,KP_Enter";*/
      /*  kb-accept-custom: "Control+Return";*/
      /*  kb-accept-custom-alt: "Control+Shift+Return";*/
      /*  kb-accept-alt: "Shift+Return";*/
      /*  kb-delete-entry: "Shift+Delete";*/
      /*  kb-mode-next: "Shift+Right,Control+Tab";*/
      /*  kb-mode-previous: "Shift+Left,Control+ISO_Left_Tab";*/
      /*  kb-mode-complete: "Control+l";*/
      /*  kb-row-left: "Control+Page_Up";*/
      /*  kb-row-right: "Control+Page_Down";*/
      /*  kb-row-up: "Up,Control+p";*/
      /*  kb-row-down: "Down,Control+n";*/
      /*  kb-row-tab: "";*/
      /*  kb-element-next: "Tab";*/
      /*  kb-element-prev: "ISO_Left_Tab";*/
      /*  kb-page-prev: "Page_Up";*/
      /*  kb-page-next: "Page_Down";*/
      /*  kb-row-first: "Home,KP_Home";*/
      /*  kb-row-last: "End,KP_End";*/
      /*  kb-row-select: "Control+space";*/
      /*  kb-screenshot: "Alt+S";*/
      /*  kb-ellipsize: "Alt+period";*/
      /*  kb-toggle-case-sensitivity: "grave,dead_grave";*/
      /*  kb-toggle-sort: "Alt+grave";*/
      /*  kb-cancel: "Escape,Control+g,Control+bracketleft";*/
      /*  kb-custom-1: "Alt+1";*/
      /*  kb-custom-2: "Alt+2";*/
      /*  kb-custom-3: "Alt+3";*/
      /*  kb-custom-4: "Alt+4";*/
      /*  kb-custom-5: "Alt+5";*/
      /*  kb-custom-6: "Alt+6";*/
      /*  kb-custom-7: "Alt+7";*/
      /*  kb-custom-8: "Alt+8";*/
      /*  kb-custom-9: "Alt+9";*/
      /*  kb-custom-10: "Alt+0";*/
      /*  kb-custom-11: "Alt+exclam";*/
      /*  kb-custom-12: "Alt+at";*/
      /*  kb-custom-13: "Alt+numbersign";*/
      /*  kb-custom-14: "Alt+dollar";*/
      /*  kb-custom-15: "Alt+percent";*/
      /*  kb-custom-16: "Alt+dead_circumflex";*/
      /*  kb-custom-17: "Alt+ampersand";*/
      /*  kb-custom-18: "Alt+asterisk";*/
      /*  kb-custom-19: "Alt+parenleft";*/
      /*  kb-select-1: "Super+1";*/
      /*  kb-select-2: "Super+2";*/
      /*  kb-select-3: "Super+3";*/
      /*  kb-select-4: "Super+4";*/
      /*  kb-select-5: "Super+5";*/
      /*  kb-select-6: "Super+6";*/
      /*  kb-select-7: "Super+7";*/
      /*  kb-select-8: "Super+8";*/
      /*  kb-select-9: "Super+9";*/
      /*  kb-select-10: "Super+0";*/
      /*  kb-entry-history-up: "Control+Up";*/
      /*  kb-entry-history-down: "Control+Down";*/
      /*  kb-matcher-up: "Super+equal";*/
      /*  kb-mather-down: "Super+minus";*/
      /*  ml-row-left: "ScrollLeft";*/
      /*  ml-row-right: "ScrollRight";*/
      /*  ml-row-up: "ScrollUp";*/
      /*  ml-row-down: "ScrollDown";*/
      /*  me-select-entry: "MousePrimary";*/
      /*  me-accept-entry: "MouseDPrimary";*/
      /*  me-accept-custom: "Control+MouseDPrimary";*/
        timeout {
            action: "kb-cancel";
            delay:  0;
        }
        filebrowser {
            directories-first: true;
            sorting-method:    "name";
        }
      }
      @theme "raycast"
    '';

    xdg.configFile."rofi/raycast.rasi".text = ''
      /* ________Variables________ */
      * {
        /* ________Window________ */
        window-width: 800px;
        window-height: 550px;
        window-border: 1.75px;
        window-border-color: #${config.lib.stylix.colors.base01};
        window-border-radius: 12px;
        window-bg-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.65
        );

        bg-col-light: #${config.lib.stylix.colors.base01};
        selected-col: #${config.lib.stylix.colors.base02};
        blue: #${config.lib.stylix.colors.base0D};
        fg-col: #${config.lib.stylix.colors.base05};
        fg-col2: #${config.lib.stylix.colors.base0E};
        grey: #${config.lib.stylix.colors.base03};
      }

      /* ________Main window________ */
      window {
        width: @window-width;
        border: @window-border;
        border-color: @window-border-color;
        background-color: @window-bg-color;
        border-radius: @window-border-radius;
      }

      /* ________Main view inside the window________ */
      mainbox {
        background-color: transparent;
        children: [inputbar, listview];
      }

      textbox {
        expand: false;
        str: "Application";
        background-color: transparent;
        text-color: rgba(
          ${config.lib.stylix.colors.base05-rgb-r},
          ${config.lib.stylix.colors.base05-rgb-g},
          ${config.lib.stylix.colors.base05-rgb-b},
          0.75
        );
        font: "NotoSans 14px";
        vertical-align: 0.5;
      }

      inputbar {
        children: [entry];
        background-color: transparent;
        border-color: #${config.lib.stylix.colors.base05};
      }

      entry {
        placeholder-color: rgba(
          ${config.lib.stylix.colors.base05-rgb-r},
          ${config.lib.stylix.colors.base05-rgb-g},
          ${config.lib.stylix.colors.base05-rgb-b},
          0.3
        );
        padding: 18px 14px;
        text-color: #${config.lib.stylix.colors.base05};
        border-color: rgba(
          ${config.lib.stylix.colors.base05-rgb-r},
          ${config.lib.stylix.colors.base05-rgb-g},
          ${config.lib.stylix.colors.base05-rgb-b},
          0.1
        );
        border: 0 0 2px 0;
        background-color: transparent;
      }

      listview {
        padding: 6px;
        lines: 7;
        spacing: 5px;
        background-color: transparent;
      }

      element {
        padding: 12px;
        border-radius: 8px;
        border: 0;
        background-color: transparent;
        text-color: #${config.lib.stylix.colors.base0D};
        spacing: 10px;
        children: [group, textbox];
      }

      group {
        background-color: transparent;
        orientation: horizontal;
        spacing: 10px;
        children: [element-icon, element-text];
      }

      element hover {
        background-color: #${config.lib.stylix.colors.base0A};
      }

      element-icon {
        size: 30px;
        background-color: transparent;
      }

      element-text {
        font: "NotoSans 16px";
        vertical-align: 0.5;
        text-color: #${config.lib.stylix.colors.base05};
        background-color: transparent;
      }

      element selected {
        background-color: rgba(
          ${config.lib.stylix.colors.base02-rgb-r},
          ${config.lib.stylix.colors.base02-rgb-g},
          ${config.lib.stylix.colors.base02-rgb-b},
          0.75
        );
      }
    '';

  };
}
