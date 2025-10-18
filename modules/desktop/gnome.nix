{ config, pkgs, lib, ... }:
let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ]; # Solo en nixos
  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    
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
    ];
    
    # Configurar asociaciones de archivos por defecto
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
  };
}
