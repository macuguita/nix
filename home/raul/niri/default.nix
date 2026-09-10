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

            # Don't let apps restore a "maximized" state when they open (some
            # clients remember it and then look like they started fullscreen).
            # Mirrors the old suppress-maximize-events rule; maximize manually.
            {
              window-rule = {
                _children = [
                  { "open-maximized-to-edges" = false; }
                ];
              };
            }
          ];

          coreBinds = {
            "Mod+T" = {
              _props.repeat = false;
              spawn = [ terminal ];
            };

            "Mod+Q" = {
              _props.repeat = false;
              close-window = { };
            };

            "Mod+F" = {
              _props.repeat = false;
              spawn = [ fileManager ];
            };

            "Mod+B" = {
              _props.repeat = false;
              spawn = [ browser ];
            };

            "Mod+Space" = {
              _props.repeat = false;
              spawn = launcher;
            };

            "Mod+MouseBack" = {
              _props.repeat = false;
              toggle-window-floating = { };
            };

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

            "Mod+Shift+5" = {
              _props.repeat = false;
              spawn = [ "${pkgs.record}/bin/record" ];
            };

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

            "Mod+O" = {
              _props.repeat = false;
              toggle-overview = { };
            };

            "Mod+Escape" = {
              toggle-keyboard-shortcuts-inhibit = { };
            };

            "Mod+Shift+E" = {
              _props.repeat = false;
              quit = { };
            };
          };

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

            "Mod+Shift+WheelScrollDown" = {
              _props.cooldown-ms = 150;
              focus-column-right = { };
            };
            "Mod+Shift+WheelScrollUp" = {
              _props.cooldown-ms = 150;
              focus-column-left = { };
            };

            "Mod+Ctrl+Shift+WheelScrollDown" = {
              _props.cooldown-ms = 150;
              move-column-right = { };
            };
            "Mod+Ctrl+Shift+WheelScrollUp" = {
              _props.cooldown-ms = 150;
              move-column-left = { };
            };
          };

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
          };
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

            # always keep an empty workspace above the first one, so scrolling
            # up from workspace 1 keeps going somewhere
            "empty-workspace-above-first" = { };

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

          binds = coreBinds // layoutBinds // workspaceBinds;
        };
    };
  };
}
