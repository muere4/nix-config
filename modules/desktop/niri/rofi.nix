{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      rofi-wayland
    ];

    home-manager.users.${userName} = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        font = "JetBrainsMono Nerd Font 15";
        terminal = "${pkgs.kitty}/bin/kitty";

        extraConfig = {
          modi = "drun,run,filebrowser,window";
          show-icons = false;
          display-drun = "drun";
          display-run = "run";
          display-filebrowser = "files";
          display-window = "windows";
          drun-display-format = "{name}";
          window-format = "{w} · {c} · {t}";
        };
      };

      # Tema de Rofi (shado)
      xdg.configFile."rofi/themes/shado.rasi".text = ''
        * {
            background:      #050e14;
            background-alt:  #282A2E80;
            foreground:      #C5C8C6;
            selected:        #F07489;
            active:          #6E77FF;
            urgent:          #8E3596;
        }
      '';

      # Config principal de Rofi
      xdg.configFile."rofi/config.rasi".text = ''
        @import "./themes/shado.rasi"

        * {
            border-colour:               var(selected);
            handle-colour:               var(selected);
            background-colour:           var(background);
            foreground-colour:           var(foreground);
            alternate-background:        var(background-alt);
            font: "JetBrainsMono Nerd Font 15";
        }

        window {
            transparency:                "real";
            location:                    center;
            anchor:                      center;
            fullscreen:                  false;
            width:                       900px;
            enabled:                     true;
            border-radius:               0px;
            cursor:                      "default";
            background-color:            @background-colour;
        }

        mainbox {
            enabled:                     true;
            spacing:                     10px;
            padding:                     40px;
            background-color:            transparent;
            children:                    [ "inputbar", "message", "listview", "mode-switcher" ];
        }

        inputbar {
            enabled:                     true;
            spacing:                     10px;
            padding:                     10px 5px;
            border:                      0px 0px 1px 0px;
            border-color:                @border-colour;
            background-color:            @background-colour;
            text-color:                  @foreground-colour;
            children:                    [ "entry" ];
        }

        entry {
            enabled:                     true;
            background-color:            inherit;
            text-color:                  inherit;
            cursor:                      text;
            placeholder:                 "search...";
            placeholder-color:           inherit;
        }

        listview {
            enabled:                     true;
            columns:                     1;
            lines:                       10;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   true;
            layout:                      vertical;
            spacing:                     10px;
            background-color:            transparent;
            text-color:                  @foreground-colour;
        }

        element {
            enabled:                     true;
            spacing:                     10px;
            padding:                     2px;
            border-radius:               0px;
            background-color:            transparent;
            text-color:                  @foreground-colour;
            cursor:                      pointer;
        }

        element selected.normal {
            background-color:            @selected;
            text-color:                  @background;
        }

        mode-switcher {
            enabled:                     true;
            spacing:                     0px;
            background-color:            transparent;
            text-color:                  @foreground-colour;
        }

        button {
            padding:                     5px;
            border-radius:               0px;
            background-color:            @background-colour;
            text-color:                  inherit;
            cursor:                      pointer;
        }

        button selected {
            background-color:            @selected;
            text-color:                  @background;
        }
      '';
    };
  };
}
