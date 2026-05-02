{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.profiles.graphical.enable {
    catppuccin.cursors = {
      enable = true;
      accent = "dark";
    };

    home.pointerCursor = {
      enable = true;
      size = 24;
      dotIcons.enable = false;
      gtk.enable = true;

      x11.enable = false;
    };

    home.packages = with pkgs; [
      wl-clipboard
      screenshot
      changeVolume
      record
      ddcutil
      hyprpicker
      nemo
    ];

    services.hyprpolkitagent.enable = true;
    # services.kdeconnect.enable = true;

    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications = lib.attrsets.genAttrs [
      "inode/directory"
      # "application/x-gnome-saved-search"
    ] (f: "nemo.desktop");

    # TODO: quickshell notis
    services.dunst.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      systemd = {
        enable = true;
      };

      settings = {
        "$mod" = "SUPER";

        monitor = lib.attrsets.mapAttrsToList (
          name: monitor:
          with monitor;
          "${name},${toString width}x${toString height}@${toString refreshRate},${toString offsetX}x${toString offsetY},1"
        ) osConfig.macuguita.monitors;

        input = {
          kb_layout = "es";

          follow_mouse = true;
          float_switch_override_focus = true;

          sensitivity = if osConfig.macuguita.hardware.touchpad then 0.5 else 2.0;
          accel_profile = "flat";

          # unnatural scroll
          touchpad.natural_scroll = false;
          touchpad.disable_while_typing = false;
        };

        # device = {
        #   name = "wacom-co.-ltd.-wacom-one-pen-tablet-small";
        #   output = builtins.elemAt (builtins.attrNames (
        #     lib.attrsets.filterAttrs (name: value: value.primary) osConfig.macuguita.monitors
        #   )) 0;
        # };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        xwayland = {
          use_nearest_neighbor = true;
          force_zero_scaling = true;
        };

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

        exec-once = [
          "[workspace 1 silent] hyprctl dispatch exec helium"
          "[workspace special:discord silent] vesktop"
        ];

        bindm = [
          # Window manip
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindel = [
          # Volume up/down
          ", XF86AudioRaiseVolume, exec, ${pkgs.changeVolume}/bin/changeVolume up"
          ", XF86AudioLowerVolume, exec, ${pkgs.changeVolume}/bin/changeVolume down"
          ", XF86AudioMute, exec, ${pkgs.changeVolume}/bin/changeVolume mute"

          # Brightness up/down
          "$mod, XF86AudioRaiseVolume, exec, ddcutil setvcp 10 + 10"
          "$mod, XF86AudioLowerVolume, exec, ddcutil setvcp 10 - 10"
        ];

        bind = [
          "$mod, T, exec, ghostty"
          "$mod, Q, killactive"
          "$mod, F, exec, nemo"
          "$mod, B, exec, helium"
          "$mod, mouse:275, togglefloating"
          "$mod, A, togglesplit"

          "$mod SHIFT, 3, exec, ${pkgs.screenshot}/bin/screenshot fullscreen"
          "$mod SHIFT, 4, exec, ${pkgs.screenshot}/bin/screenshot area"
          "$mod SHIFT, 5, exec, ${pkgs.record}/bin/record"
          # "$mod SHIFT, P, exec, ${pkgs.colorpicker}/bin/colorpicker"

          "$mod, S, togglespecialworkspace, discord"
          "$mod Control_L&Control_R, S, movetoworkspace, special:discord"

          "$mod, SPACE, exec, vicinae toggle"
        ]
        ++ builtins.concatLists (
          builtins.genList (
            i:
            let
              workspace = i + 1;
            in
            [
              "$mod, ${toString workspace}, workspace, ${toString workspace}"
              "$mod Control_L&Control_R, ${toString workspace}, movetoworkspace, ${toString workspace}"
            ]
          ) 9
        );

        general = {
          gaps_out = 20;

          border_size = 0;
          "col.active_border" = "0x00000000";
          "col.inactive_border" = "0x00000000";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;

          shadow = {
            enabled = true;
            range = 15;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 2;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        windowrule = [
          {
             name = "vesktop special";
             "match:class" = "vesktop|discord";
             workspace = "special:discord";
          }
          {
            name = "jetbrains fix";
            "match:class" = "^jetbrains-.*$";
            "match:float" = true;
            "match:title" = "^$|^\\s$|^win\\d+$";
          }
          {
            name = "sober services float";
            "match:class" = "^(sober_services)$";
            float = "on";
          }
          {
            name = "sober tile";
            "match:class" = "^(org\\.vinegarhq\\.Sober)$";
            "match:title" = "^(Sober)$";
            tile = "on";
          }
        ];

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 2.23, easeInOutCubic, slide"
            "workspacesIn, 1, 2.21, easeInOutCubic, slide"
            "workspacesOut, 1, 2.47, easeInOutCubic, slide"
            "specialWorkspace, 1, 1.94, almostLinear, fade"
            "specialWorkspaceIn, 1, 1.21, almostLinear, fade"
            "specialWorkspaceOut, 1, 1.94, almostLinear, fade"
          ];
        };
      };
    };
  };
}
