{ config, pkgs, lib, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";

  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" ''
    QT_QPA_PLATFORM=wayland ${pkgs.flameshot}/bin/flameshot gui
  '';

  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    services.xserver.enable = true;
    
    # ← NUEVAS LÍNEAS (reemplazar las viejas)
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.pop-shell
      gnomeExtensions.transparent-window-moving
      gnomeExtensions.caffeine
      gnomeExtensions.user-themes
      flameshot-gui
      flameshot
      qt5.qtwayland
    ];

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/x-nix" = "org.gnome.TextEditor.desktop";
        "text/x-python" = "org.gnome.TextEditor.desktop";
        "text/x-shellscript" = "org.gnome.TextEditor.desktop";
        "text/x-csrc" = "org.gnome.TextEditor.desktop";
        "text/x-c++src" = "org.gnome.TextEditor.desktop";
        "text/x-java" = "org.gnome.TextEditor.desktop";
        "text/javascript" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/css" = "org.gnome.TextEditor.desktop";
        "text/xml" = "org.gnome.TextEditor.desktop";
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "application/json" = "org.gnome.TextEditor.desktop";
        "application/x-yaml" = "org.gnome.TextEditor.desktop";
        "application/xml" = "org.gnome.TextEditor.desktop";
      };
    };

    environment.variables = {
      GSK_RENDERER = "ngl";
    };

    home-manager.users.${userName} = { config, ... }: {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          accent-color = "purple";
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot" = {
          name = "Flameshot";
          command = "${flameshot-gui}/bin/flameshot-gui";
          binding = "<Control>ntilde";
        };
      };
    };
  };
}
