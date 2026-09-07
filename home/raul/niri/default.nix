{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    wayland.windowManager.niri = {
      enable = true;

      # Portal and session wiring is handled by the NixOS `programs.niri` module.
      portalPackage = null;

      settings =
        let
          terminal = "foot";
          browser = "helium";
          fileManager = "nemo";
          launcher = [
            "vicinae"
            "toggle"
          ];

          # catppuccin mocha
          accent = "#89b4fa";
          inactive = "#585b70";

          monitorNodes = lib.mapAttrsToList (name: monitor: {
            output = {
              _args = [ name ];
              mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}";
              scale = monitor.scale;
            }
            // lib.optionalAttrs (monitor.offsetX != 0 || monitor.offsetY != 0) {
              position._props = {
                x = monitor.offsetX;
                y = monitor.offsetY;
              };
            };
          }) osConfig.macuguita.monitors;

          windowRuleNodes = [
            # JetBrains helper popups have empty/technical titles and float.
            {
              window-rule = {
                _children = [
                  {
                    match._props = {
                      app-id = "^jetbrains-.*$";
                      title = "^$|^\\s+$|^win\\d+$";
                    };
                  }
                  { open-floating = true; }
                ];
              };
            }

            # Sober (Roblox) helper service window floats.
            {
              window-rule = {
                _children = [
                  {
                    match._props.app-id = "^sober_services$";
                  }
                  { open-floating = true; }
                ];
              };
            }

            # Round every window the same way Hyprland's decoration.rounding did.
            {
              window-rule = {
                _children = [
                  { geometry-corner-radius = 10; }
                  { clip-to-geometry = true; }
                ];
              };
            }
          ];

          # hyprland's split toggle (Mod + A) has no niri equivalent;
          # the column-based layout is controlled by consume/expel and width binds.

          coreBinds = {
            # Terminal
            "Mod+T" = {
              _props.repeat = false;
              spawn = [ terminal ];
            };

            # Close
            "Mod+Q" = {
              _props.repeat = false;
              close-window = { };
            };

            # File manager
            "Mod+F" = {
              _props.repeat = false;
              spawn = [ fileManager ];
            };

            # Browser
            "Mod+B" = {
              _props.repeat = false;
              spawn = [ browser ];
            };

            # Launcher
            "Mod+Space" = {
              _props.repeat = false;
              spawn = launcher;
            };

            # Floating (keyboard and back button, mirroring Mod + mouse:275)
            "Mod+V" = {
              _props.repeat = false;
              toggle-window-floating = { };
            };
            "Mod+MouseBack" = {
              _props.repeat = false;
              toggle-window-floating = { };
            };

            # Screenshots
            "Mod+Shift+3" = {
              _props.repeat = false;
              spawn = [
                "${pkgs.screenshot}/bin/screenshot"
                "fullscreen"
              ];
            };
            "Mod+Shift+4" = {
              _props.repeat = false;
              spawn = [
                "${pkgs.screenshot}/bin/screenshot"
                "area"
              ];
            };

            # Recording
            "Mod+Shift+5" = {
              _props.repeat = false;
              spawn = [ "${pkgs.record}/bin/record" ];
            };

            # Volume
            "XF86AudioRaiseVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "${pkgs.changeVolume}/bin/changeVolume"
                "up"
              ];
            };
            "XF86AudioLowerVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "${pkgs.changeVolume}/bin/changeVolume"
                "down"
              ];
            };
            "XF86AudioMute" = {
              _props."allow-when-locked" = true;
              spawn = [
                "${pkgs.changeVolume}/bin/changeVolume"
                "mute"
              ];
            };

            # Brightness (external monitor via DDC)
            "Mod+XF86AudioRaiseVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "ddcutil"
                "setvcp"
                "10"
                "+ 10"
              ];
            };
            "Mod+XF86AudioLowerVolume" = {
              _props."allow-when-locked" = true;
              spawn = [
                "ddcutil"
                "setvcp"
                "10"
                "- 10"
              ];
            };

            # Overview
            "Mod+O" = {
              _props.repeat = false;
              toggle-overview = { };
            };

            # Escape hatch for apps that inhibit niri's shortcuts
            "Mod+Escape" = {
              toggle-keyboard-shortcuts-inhibit = { };
            };

            # Quit
            "Mod+Shift+E" = {
              _props.repeat = false;
              quit = { };
            };
          };

          # Window layout / column binds
          layoutBinds = {
            "Mod+Left" = {
              focus-column-left = { };
            };
            "Mod+Right" = {
              focus-column-right = { };
            };
            "Mod+Up" = {
              focus-window-up = { };
            };
            "Mod+Down" = {
              focus-window-down = { };
            };
            "Mod+Home" = {
              focus-column-first = { };
            };
            "Mod+End" = {
              focus-column-last = { };
            };

            "Mod+Ctrl+Left" = {
              move-column-left = { };
            };
            "Mod+Ctrl+Right" = {
              move-column-right = { };
            };
            "Mod+Ctrl+Up" = {
              move-window-up = { };
            };
            "Mod+Ctrl+Down" = {
              move-window-down = { };
            };
            "Mod+Ctrl+Home" = {
              move-column-to-first = { };
            };
            "Mod+Ctrl+End" = {
              move-column-to-last = { };
            };

            "Mod+BracketLeft" = {
              consume-or-expel-window-left = { };
            };
            "Mod+BracketRight" = {
              consume-or-expel-window-right = { };
            };

            "Mod+R" = {
              _props.repeat = false;
              switch-preset-column-width = { };
            };
            "Mod+Shift+R" = {
              _props.repeat = false;
              switch-preset-column-width-back = { };
            };

            "Mod+Shift+F" = {
              _props.repeat = false;
              fullscreen-window = { };
            };
            "Mod+M" = {
              _props.repeat = false;
              maximize-window-to-edges = { };
            };
          };

          # Workspace binds
          workspaceBinds = {
            "Mod+Page_Down" = {
              focus-workspace-down = { };
            };
            "Mod+Page_Up" = {
              focus-workspace-up = { };
            };
            "Mod+Ctrl+Page_Down" = {
              move-column-to-workspace-down = { };
            };
            "Mod+Ctrl+Page_Up" = {
              move-column-to-workspace-up = { };
            };

            "Mod+WheelScrollDown" = {
              _props."cooldown-ms" = 150;
              focus-workspace-down = { };
            };
            "Mod+WheelScrollUp" = {
              _props."cooldown-ms" = 150;
              focus-workspace-up = { };
            };
            "Mod+Ctrl+WheelScrollDown" = {
              _props."cooldown-ms" = 150;
              move-column-to-workspace-down = { };
            };
            "Mod+Ctrl+WheelScrollUp" = {
              _props."cooldown-ms" = 150;
              move-column-to-workspace-up = { };
            };

            "Mod+WheelScrollRight" = {
              focus-column-right = { };
            };
            "Mod+WheelScrollLeft" = {
              focus-column-left = { };
            };
          };

          numberBinds = builtins.foldl' (
            acc: i:
            let
              ws = toString i;
            in
            acc
            // {
              "Mod+${ws}" = {
                focus-workspace = i;
              };
              "Mod+Ctrl+${ws}" = {
                move-column-to-workspace = i;
              };
            }
          ) { } (lib.genList (i: i + 1) 9);
        in
        {
          input = {
            keyboard.xkb.layout = "es";

            mouse.accel-profile = "flat";

            focus-follows-mouse = {
              _props."max-scroll-amount" = "100%";
            };
          };

          layout = {
            gaps = 12;

            border = {
              off = { };
            };

            focus-ring = {
              width = 2;
              "active-color" = accent;
              "inactive-color" = inactive;
            };

            shadow = {
              on = { };
              softness = 15;
              spread = 2;
              offset._props = {
                x = 0;
                y = 3;
              };
              color = "#1a1a1aee";
            };
          };

          animations = {
            "workspace-switch" = {
              "duration-ms" = 250;
              curve = [
                "cubic-bezier"
                0.65
                0.05
                0.36
                1
              ];
            };
            "window-open" = {
              "duration-ms" = 200;
              curve = [
                "cubic-bezier"
                0.23
                1
                0.32
                1
              ];
            };
            "window-close" = {
              "duration-ms" = 150;
              curve = [ "linear" ];
            };
            "window-movement" = {
              "duration-ms" = 250;
              curve = [
                "cubic-bezier"
                0.65
                0.05
                0.36
                1
              ];
            };
          };

          "prefer-no-csd" = { };

          "hotkey-overlay" = {
            "skip-at-startup" = { };
          };

          _children = monitorNodes ++ windowRuleNodes;

          binds = coreBinds // layoutBinds // workspaceBinds // numberBinds;
        };
    };
  };
}
