{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    # when fixed re-add
    catppuccin.hyprland.enable = false;

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      systemd = {
        enable = true;
      };

      settings =
        let
          mod = "SUPER";
          browser = "helium";
          terminal = "foot";
          fileManager = "nemo";
          launcher = "vicinae toggle";

          util = import ./hyprUtil.nix { inherit lib; };
        in
        {
          monitor = lib.attrsets.mapAttrsToList (
            name: monitor: with monitor; {
              output = name;
              mode = "${toString width}x${toString height}@${toString refreshRate}";
              position = "${toString offsetX}x${toString offsetY}";
              scale = "${toString scale}";
            }
          ) osConfig.macuguita.monitors;

          config = {
            general = {
              border_size = 0;
              layout = "dwindle";
            };

            decoration = {
              rounding = 10;
              rounding_power = 2;
              blur = {
                enabled = true;
                size = 2;
                passes = 1;
                vibrancy = 0.1696;
              };
              shadow = {
                enabled = true;
                range = 15;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };
            };
            animations.enabled = true;
            input = {
              kb_layout = "es";

              follow_mouse = true;
              float_switch_override_focus = 1;

              sensitivity = if osConfig.macuguita.hardware.touchpad then 0.5 else 2.0;
              accel_profile = "flat";

              # unnatural scroll
              touchpad.natural_scroll = false;
              touchpad.disable_while_typing = false;
            };
            dwindle.preserve_split = true;
            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;

              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;

              animate_mouse_windowdragging = true;
              animate_manual_resizes = true;

              enable_anr_dialog = false;
            };
            ecosystem.no_donation_nag = true;
          };
          curve = [
            (util.mkBezier "easeOutQuint" [ 0.23 1 ] [ 0.32 1 ])
            (util.mkBezier "easeInOutCubic" [ 0.65 0.05 ] [ 0.36 1 ])
            (util.mkBezier "linear" [ 0 0 ] [ 1 1 ])
            (util.mkBezier "almostLinear" [ 0.5 0.5 ] [ 0.75 1 ])
            (util.mkBezier "quick" [ 0.15 0 ] [ 0.1 1 ])

            (util.mkSpring "easy" {
              mass = 1;
              stiffness = 71.2633;
              dampening = 15.8273644;
            })
          ];
          animation = [
            (util.mkAnimation {
              leaf = "global";
              enabled = 1;
              speed = 10;
              bezier = "default";
            })

            (util.mkAnimation {
              leaf = "border";
              enabled = 1;
              speed = 5.39;
              bezier = "easeOutQuint";
            })

            (util.mkAnimation {
              leaf = "windows";
              enabled = 1;
              speed = 4.79;
              bezier = "easeOutQuint";
            })

            (util.mkAnimation {
              leaf = "windowsIn";
              enabled = 1;
              speed = 4.1;
              bezier = "easeOutQuint";
              style = "popin 87%";
            })

            (util.mkAnimation {
              leaf = "windowsOut";
              enabled = 1;
              speed = 1.49;
              bezier = "linear";
              style = "popin 87%";
            })

            (util.mkAnimation {
              leaf = "fadeIn";
              enabled = 1;
              speed = 1.73;
              bezier = "almostLinear";
            })

            (util.mkAnimation {
              leaf = "fadeOut";
              enabled = 1;
              speed = 1.46;
              bezier = "almostLinear";
            })

            (util.mkAnimation {
              leaf = "fade";
              enabled = 1;
              speed = 3.03;
              bezier = "quick";
            })

            (util.mkAnimation {
              leaf = "layers";
              enabled = 1;
              speed = 3.81;
              bezier = "easeOutQuint";
            })

            (util.mkAnimation {
              leaf = "layersIn";
              enabled = 1;
              speed = 4;
              bezier = "easeOutQuint";
              style = "fade";
            })

            (util.mkAnimation {
              leaf = "layersOut";
              enabled = 1;
              speed = 1.5;
              bezier = "linear";
              style = "fade";
            })

            (util.mkAnimation {
              leaf = "fadeLayersIn";
              enabled = 1;
              speed = 1.79;
              bezier = "almostLinear";
            })

            (util.mkAnimation {
              leaf = "fadeLayersOut";
              enabled = 1;
              speed = 1.39;
              bezier = "almostLinear";
            })

            (util.mkAnimation {
              leaf = "workspaces";
              enabled = 1;
              speed = 2.23;
              bezier = "easeInOutCubic";
              style = "slide";
            })

            (util.mkAnimation {
              leaf = "workspacesIn";
              enabled = 1;
              speed = 2.21;
              bezier = "easeInOutCubic";
              style = "slide";
            })

            (util.mkAnimation {
              leaf = "workspacesOut";
              enabled = 1;
              speed = 2.47;
              bezier = "easeInOutCubic";
              style = "slide";
            })

            (util.mkAnimation {
              leaf = "specialWorkspace";
              enabled = 1;
              speed = 1.94;
              bezier = "almostLinear";
              style = "fade";
            })

            (util.mkAnimation {
              leaf = "specialWorkspaceIn";
              enabled = 1;
              speed = 1.21;
              bezier = "almostLinear";
              style = "fade";
            })

            (util.mkAnimation {
              leaf = "specialWorkspaceOut";
              enabled = 1;
              speed = 1.94;
              bezier = "almostLinear";
              style = "fade";
            })
          ];
          on = {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("helium")
                  hl.exec_cmd("vesktop")
                end
              '')
            ];
          };
          bind = [

            # Terminal
            (util.mkBind {
              key = "${mod} + T";
              action = util.dsp.exec "${terminal}";
            })

            # Close
            (util.mkBind {
              key = "${mod} + Q";
              action = util.dsp.close;
            })

            # File manager
            (util.mkBind {
              key = "${mod} + F";
              action = util.dsp.exec "${fileManager}";
            })

            # Browser
            (util.mkBind {
              key = "${mod} + B";
              action = util.dsp.exec "${browser}";
            })

            # Floating
            (util.mkBind {
              key = "${mod} + mouse:275";
              action = util.dsp.toggleFloat;
              opts.mouse = true;
            })

            # Split
            (util.mkBind {
              key = "${mod} + A";
              action = util.dsp.toggleSplit;
            })

            # Screenshots
            (util.mkBind {
              key = "${mod} + SHIFT + 3";
              action = util.dsp.exec "${pkgs.screenshot}/bin/screenshot fullscreen";
            })

            (util.mkBind {
              key = "${mod} + SHIFT + 4";
              action = util.dsp.exec "${pkgs.screenshot}/bin/screenshot area";
            })

            (util.mkBind {
              key = "${mod} + SHIFT + 5";
              action = util.dsp.exec "${pkgs.record}/bin/record";
            })

            # Special workspace
            (util.mkBind {
              key = "${mod} + S";
              action = util.dsp.special "discord";
            })

            (util.mkBind {
              key = "${mod} + CTRL + S";
              action = util.dsp.moveToWorkspace "special:discord";
            })

            # Vicinae
            (util.mkBind {
              key = "${mod} + SPACE";
              action = util.dsp.exec "${launcher}";
            })

            # Mouse move window
            (util.mkBind {
              key = "${mod} + mouse:272";
              action = util.lua "hl.dsp.window.drag()";
              opts.mouse = true;
            })

            # Mouse resize window
            (util.mkBind {
              key = "${mod} + mouse:273";
              action = util.lua "hl.dsp.window.resize()";
              opts.mouse = true;
            })

            # Volume up
            (util.mkBind {
              key = "XF86AudioRaiseVolume";
              action = util.dsp.exec "${pkgs.changeVolume}/bin/changeVolume up";

              opts = {
                locked = true;
                repeating = true;
              };
            })

            # Volume down
            (util.mkBind {
              key = "XF86AudioLowerVolume";
              action = util.dsp.exec "${pkgs.changeVolume}/bin/changeVolume down";

              opts = {
                locked = true;
                repeating = true;
              };
            })

            # Mute
            (util.mkBind {
              key = "XF86AudioMute";
              action = util.dsp.exec "${pkgs.changeVolume}/bin/changeVolume mute";

              opts.locked = true;
            })

            # Brightness up
            (util.mkBind {
              key = "${mod} + XF86AudioRaiseVolume";
              action = util.dsp.exec "ddcutil setvcp 10 + 10";

              opts = {
                locked = true;
                repeating = true;
              };
            })

            # Brightness down
            (util.mkBind {
              key = "${mod} + XF86AudioLowerVolume";
              action = util.dsp.exec "ddcutil setvcp 10 - 10";

              opts = {
                locked = true;
                repeating = true;
              };
            })
          ]
          ++ builtins.concatLists (
            builtins.genList (
              i:
              let
                workspace = i + 1;
                ws = toString workspace;
              in
              [
                (util.mkBind {
                  key = "${mod} + ${ws}";
                  action = util.dsp.workspace workspace;
                })

                (util.mkBind {
                  key = "${mod} + CTRL + ${ws}";
                  action = util.dsp.moveToWorkspace workspace;
                })
              ]
            ) 9
          );
          window_rule = [
            (util.mkWindowRule {
              name = "suppress-maximize-events";
              match.class = ".*";
              suppress_event = "maximize";
            })

            (util.mkWindowRule {
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };
              no_focus = true;
            })

            (util.mkWindowRule {
              name = "vesktop special";

              match.class = "vesktop|discord";

              workspace = "special:discord silent";
            })

            (util.mkWindowRule {
              name = "jetbrains fix";

              match = {
                class = "^jetbrains-.*$";
                float = true;
                title = "^$|^\\s$|^win\\d+$";
              };

              no_initial_focus = true;
            })

            (util.mkWindowRule {
              name = "sober services float";

              match.class = "^(sober_services)$";

              float = true;
            })

            (util.mkWindowRule {
              name = "sober tile";

              match = {
                class = "^(org\\.vinegarhq\\.Sober)$";
                title = "^(Sober)$";
              };

              tile = true;
            })
          ];
        };
    };
  };
}
