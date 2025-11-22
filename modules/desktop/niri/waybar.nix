{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    programs.waybar.enable = true;

    home-manager.users.${userName} = {
      programs.waybar = {
        enable = true;
        systemd.enable = false;  # Lo lanzamos desde niri config

        settings = [{
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "niri/workspaces" "clock" ];
          modules-center = [ "niri/window" ];
          modules-right = [ "bluetooth" "tray" "pulseaudio" "battery" "custom/power" ];

          "niri/workspaces" = {
            disable-scroll = false;
            on-click = "activate";
            format = "{icon}";
            format-icons = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
            };
            persistent-workspaces = {
              "*" = 5;
            };
          };

          "niri/window" = {
            format = "{}";
            max-length = 50;
          };

          clock = {
            format = "󰅐  {:%H:%M:%S}";
            format-alt = "󰅐  {:%A, %B %d, %Y}";
            interval = 1;
            tooltip-format = "<span>{calendar}</span>";
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons = [ "󰕿" "󰖀" "󰕾" ];
            format-muted = "󰝟";
            on-click = "pavucontrol";
            scroll-step = 5;
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" ];
          };

          bluetooth = {
            format = "";
            format-disabled = "󰂲";
            format-connected = " {num_connections}";
            on-click = "blueman-manager";
          };

          tray = {
            icon-size = 16;
            spacing = 2;
          };

          "custom/power" = {
            format = "⏻";
            on-click = "~/.config/niri/scripts/power-menu.sh";
            tooltip = false;
          };
        }];

        style = ''
          * {
            font-family: "JetBrainsMono Nerd Font", monospace;
            font-size: 13px;
            min-height: 0;
            transition: 150ms;
          }

          window#waybar {
            background: #191724;
            color: #e3c7fc;
            border-bottom: 2px solid #bd93f9;
          }

          #workspaces button {
            padding: 0 10px;
            background: transparent;
            color: #a8899c;
            margin: 8px 4px;
            border-radius: 1rem;
          }

          #workspaces button.active {
            background: #bd93f9;
            color: #191724;
            font-weight: bold;
          }

          #workspaces button:hover {
            background: rgba(189, 147, 249, 0.3);
            color: #bd93f9;
          }

          #window {
            padding: 0 15px;
            color: #bd93f9;
            font-weight: 500;
          }

          #clock,
          #battery,
          #bluetooth,
          #pulseaudio,
          #custom-power {
            padding: 0 12px;
            margin: 4px 4px;
            border-radius: 1rem;
            background: #140a1d;
            border: 1px solid #bd93f9;
          }

          #clock { color: #FF4971; }
          #battery { color: #a8899c; }
          #battery.charging { color: #F18FB0; }
          #battery.warning:not(.charging) { color: #FF4971; }
          #battery.critical:not(.charging) { color: #B52A5B; }
          #bluetooth { color: #8897F4; }
          #pulseaudio { color: #bd93f9; }
          #pulseaudio.muted { color: #a8899c; }
          #custom-power { color: #B52A5B; }

          #tray {
            padding: 0 10px;
            background: #140a1d;
            margin: 4px 2px;
            border-radius: 1rem;
          }
        '';
      };
    };
  };
}
