{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.hyprland;
in
{
  imports = [
    ./hyprlock.nix
    ./hyprpaper.nix
  ];
  options.myHome.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable hyprland.";
    };
  };

  config = 
  mkIf cfg.enable {
    #myHome.hyprlock.enable = true;
    myHome.hyprpaper.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
    };

    wayland.windowManager.hyprland.settings = {
      monitor = "HDMI-A-1, 1920x1080@74.97Hz, 0x0, 1";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$browser" = config.home.sessionVariables.BROWSER;
      "$menu" = "rofi -show drun -show-icons";
      "$mainMod" = "SUPER";

      exec-once = [
        "dunst &"
        "hyprpaper &"
        "waybar &"
        "[workspace 1 silent] hyprctl dispatch exec ${config.home.sessionVariables.BROWSER}"
        "[workspace special:discord silent] vesktop"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "sh $HOME/.config/scripts/randomWallpaper.sh"
        #"hyprlock"
        "hyprsunset"
        "systemctl --user start hyprpolkitagent"
      ];

      env = [
        "XDG_MENU_PREFIX,arch-"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
        "col.inactive_border" = "rgba(${config.lib.stylix.colors.base00}aa)";
        "col.active_border" = "rgba(${config.lib.stylix.colors.base01}ee) rgba(${config.lib.stylix.colors.base04}ee) rgba(${config.lib.stylix.colors.base06}ee) 135deg";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 1;
        inactive_opacity = 1;

        shadow = {
          enabled = true;
          range = 4;
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
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "master";
      };
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
      input = {
        kb_layout = "es";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0;

        touchpad.natural_scroll = false;
      };

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, F, exec, $fileManager"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, B, exec, $browser"
        "$mainMod, P, exec, colorPicker"

        # Screenshots
        "$mainMod SHIFT, 3, exec, screenshot fullscreen"
        "$mainMod SHIFT, 4, exec, screenshot area"
        "$mainMod SHIFT, 5, exec, record"

        # Autoclicker
        "$mainMod, F8, exec, toggleAutoclicker"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Special workspaces - Discord
        "$mainMod, S, togglespecialworkspace, discord"
        "$mainMod Control_L&Control_R, S, movetoworkspace, special:discord"

        # Window manip
        "$mainMod, A, togglesplit," #dwindle
        "$mainMod, mouse:275, togglefloating"
      ]
      ++ (
        # Workspaces 1..9
        builtins.concatLists (builtins.genList
          (i:
            let ws = i + 1;
            in [
              "$mainMod, ${toString ws}, workspace, ${toString ws}"
              "$mainMod CONTROL, ${toString ws}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        )
      )
      ++
      [
        # Workspace 10 for 0 key
        "$mainMod, 0, workspace, 10"
        "$mainMod CONTROL, 0, movetoworkspace, 10"
      ];
      bindm = [
        # Window manip
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        # Volume up/down
        ", XF86AudioRaiseVolume, exec, changeVolume up"
        ", XF86AudioLowerVolume, exec, changeVolume down"
        ", XF86AudioMute, exec, changeVolume mute"

        # Brightness up/down
        "$mainMod, XF86AudioLowerVolume, exec, hyprctl hyprsunset gamma -10"
        "$mainMod, XF86AudioRaiseVolume, exec, hyprctl hyprsunset gamma +10"
      ];

      windowrule = [
        {
           name = "vesktop special";
           "match:class" = "vesktop|discord";
           workspace = "special:discord";
        }
        {
           name = "browser pip";
           "match:class" = "^(${config.home.sessionVariables.BROWSER})$";
           "match:title" = "^(Picture-in-Picture)$";
           float = true;
           pin = true;
           size = "480 270";
           move = "1410 70";
         }
         {
           name = "jetbrains no initial focus windows";
           "match:class" = "^(.*jetbrains.*)$";
           "match:title" = "^(win.*)$";
           no_initial_focus = "on";
           no_focus = "on";
         }
         {
           name = "jetbrains no initial focus blank";
           "match:class" = "^(.*jetbrains.*)$";
           "match:title" = "^\\s$";
           no_initial_focus = "on";
           no_focus = "on";
         }
         {
           name = "jetbrains floating tag";
           "match:class" = "^jetbrains-.+$";
           "match:float" = "1";
           tag = "+jb";
         }
         {
           name = "jetbrains stay focused";
           "match:tag" = "jb";
           stay_focused = "on";
           no_initial_focus = "on";
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
         {
           name = "wayland boomer";
           "match:title" = "^wayland-boomer$";
           float = "on";
           monitor = "1";
           move = "0 0";
           no_anim = "on";
           rounding = "0";
         }
         {
           name = "global rules";
           no_focus = "on";
           suppress_event = "maximize";
         }
      ];
    };
    home.packages = [
      pkgs.hyprpaper
      pkgs.hyprsunset
      pkgs.hyprpolkitagent
      pkgs.hyprland-qt-support
      pkgs.waybar
      pkgs.woomer
    ];
  };
}
