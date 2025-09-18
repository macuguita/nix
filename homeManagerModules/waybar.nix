{ config
, lib
, pkgs
, ...
}:

with lib;

let
  cfg = config.myHome.waybar;
in
{
  options.myHome.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable waybar.";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."waybar/config.jsonc".text = ''
      {
          "layer": "top",
          "position": "top",
          "spacing": 0,
          "modules-left": [
            "hyprland/workspaces",
            "tray",
            "custom/lock",
            "custom/reboot",
            "custom/power"
          ],
          "modules-center": [
            "hyprland/window"
          ],
          "modules-right": [
            "custom/recording",
            "pulseaudio",
            "memory",
            "cpu",
            "clock"
          ],
          "hyprland/workspaces": {
            "disable-scroll": false,
            "all-outputs": true,
            "format": "{icon}",
            "on-click": "activate",
            "persistent-workspaces": {
            "*":[1,2,3,4,5,6,7,8,9]
            },
            "format-icons": {
              "1": "1",
              "2": "2",
              "3": "3",
              "4": "4",
              "5": "5",
              "6": "6",
              "7": "7",
              "8": "8",
              "9": "9",
              "default": "󱄅"
            }
          },
          "custom/lock": {
          "format": "    ",
          "on-click": "pidof hyprlock || hyprlock",
          "tooltip": true,
          "tooltip-format": "Cerrar sesion"
          },
          "custom/reboot": {
            "format": "    ",
            "on-click": "systemctl reboot",
            "tooltip": true,
            "tooltip-format": "Reiniciar"
          },
          "custom/power": {
            "format": "    ",
            "on-click": "systemctl poweroff",
            "tooltip": true,
            "tooltip-format": "Apagar"
          },
          "pulseaudio": {
            "format": "<span color='#00FF7F'>{icon}</span>{volume}% ",
            "format-muted": "<span color='#FF4040'> 󰖁 </span>0% ",
            "format-icons": {
              "headphone": "<span color='#BF00FF'>  </span>",
              "hands-free": "<span color='#BF00FF'>  </span>",
              "headset": "<span color='#BF00FF'>  </span>",
              "phone": "<span color='#00FFFF'>  </span>",
              "portable": "<span color='#00FFFF'>  </span>",
              "car": "<span color='#FFA500'>  </span>",
              "default": [
                "<span color='#808080'>  </span>",
                "<span color='#FFFF66'>  </span>",
                "<span color='#00FF7F'>  </span>"
              ]
            },
            "on-click-right": "sh $HOME/.config/scripts/volumeNotify.sh mute",
            "on-click": "sh $HOME/.config/scripts/volumeNotify.sh mute",
            "on-scroll-up": "sh $HOME/.config/scripts/volumeNotify.sh up",
            "on-scroll-down": "sh $HOME/.config/scripts/volumeNotify.sh down",
            "tooltip": true,
            "tooltip-format": "Volumen: {volume}%"
          },
          "custom/recording": {
            "format": "  Rec  ",
        		"return-type": "json",
        		"interval": 1,
        		"exec": "echo '{\"class\": \"recording\"}'",
        		"exec-if": "pgrep wf-recorder"
          },
          "memory": {
            "format": "  <span color='#${config.lib.stylix.colors.base05}'>{used:0.1f}G/{total:0.1f}G</span> ",
            "on-click": "ghostty -e btop",
            "tooltip": true,
            "tooltip-format": "Memoria usada: {used:0.2f}G/{total:0.2f}G"
          },
          "cpu": {
            "format": "  <span color='#${config.lib.stylix.colors.base05}'>{usage}%</span> ",
            "on-click": "ghostty -e btop",
            "tooltip": true
          },
          "clock": {
            "interval": 1,
            "timezone": "Europe/Madrid",
            "format": "  <span color='#${config.lib.stylix.colors.base05}'>{:%H:%M}</span> ",
            "tooltip": true,
            "tooltip-format": "{:%A, %d %B %Y}"
          },
          "tray": {
            "icon-size": 24,
            "spacing": 6
          }
        }
    '';

    xdg.configFile."waybar/style.css".text = ''
           * {
        font-family: "NotoSans Nerd Font";
        font-weight: bold;
        font-size: 16px;
        color: #${config.lib.stylix.colors.base05};
      }

      #waybar {
        background-color: rgba(0, 0, 0, 0); /* Fully transparent */
        border: none;
        box-shadow: none;
      }

      #workspaces {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 2px;
        margin: 8px 8px 0 18px;
        border-radius: 10px;
      }

      #workspaces button {
        min-width: 24px;
        min-height: 24px;
        padding: 0;
        margin: 0 4px;
        border-radius: 6px;
        background: transparent;
        color: #${config.lib.stylix.colors.base08};
        transition: all 0.2s ease;
      }

      #workspaces button:first-child {
        margin-left: 2px;
      }

      #workspaces button:last-child {
        margin-right: 2px;
      }

      #workspaces button.active {
        background-color: #${config.lib.stylix.colors.base04};
        color: #${config.lib.stylix.colors.base05};
      }

      #workspaces button:hover {
        background-color: rgba(
          ${config.lib.stylix.colors.base04-rgb-r},
          ${config.lib.stylix.colors.base04-rgb-g},
          ${config.lib.stylix.colors.base04-rgb-b},
          0.75
        );
        color: #${config.lib.stylix.colors.base05};
      }

      #custom-lock,
      #custom-reboot,
      #custom-power {
        font-size: 12px;
        padding: 4px 0;
        margin-top: 8px;
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        color: #${config.lib.stylix.colors.base05}; /* match workspace icon default color */
        transition: all 0.2s ease;
      }

      #custom-lock:hover {
        color: #${config.lib.stylix.colors.base0A};
      }

      #custom-reboot:hover {
        color: #${config.lib.stylix.colors.base0A};
      }

      #custom-power:hover {
        color: #${config.lib.stylix.colors.base08};
      }

      #custom-lock {
        margin-left: 6px;
        border-radius: 10px 0 0 10px;
        padding-left: 6px;
        padding-right: 4px;
      }

      #custom-power {
        margin-right: 6px;
        border-radius: 0 10px 10px 0;
        padding-left: 4px;
        padding-right: 6px;
      }

      #custom-reboot {
        border-radius: 0;
      }

      #window,
      #tray {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 12px;
        margin: 8px 6px 0 6px;
        border-radius: 10px;
        transition: all 0.2s ease;
      }

      #pulseaudio {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 12px 4px 8px;
        margin: 8px 0 0 6px;
        border-radius: 10px 0 0 10px;
        transition: all 0.2s ease;
      }

      #custom-recording {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 12px;
        margin: 8px 0 0 0;
        border-radius: 10px 10px 10px 10px;
        color: #${config.lib.stylix.colors.base04};
        transition: all 0.2s ease;
      }

      #clock {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 8px 4px 12px;
        margin: 8px 18px 0 0;
        border-radius: 0 10px 10px 0;
        color: #${config.lib.stylix.colors.base05};
        transition: all 0.2s ease;
      }

      #memory {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 12px;
        margin: 8px 0 0 0;
        color: #${config.lib.stylix.colors.base04};
        transition: all 0.2s ease;
      }

      #cpu {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.75
        );
        padding: 4px 12px;
        margin: 8px 0 0 0;
        color: #${config.lib.stylix.colors.base06};
        transition: all 0.2s ease;
      }

      #pulseaudio.muted {
        color: #FF4040;
      }

      #pulseaudio:hover,
      #custom-recording:hover,
      #memory:hover,
      #cpu:hover,
      #clock:hover,
      #custom-lock:hover,
      #custom-reboot:hover,
      #custom-power:hover,
      #window:hover,
      #tray:hover {
        background-color: rgba(
          ${config.lib.stylix.colors.base00-rgb-r},
          ${config.lib.stylix.colors.base00-rgb-g},
          ${config.lib.stylix.colors.base00-rgb-b},
          0.9
        );
      }

      #window {
        font-weight: 500;
        font-style: italic;
      }
    '';

    home.packages = [
      pkgs.waybar
    ];
  };
}
