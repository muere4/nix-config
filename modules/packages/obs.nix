{ config, lib, pkgs, ... }:

let
  # Lista de hosts donde quieres habilitar OBS
  enabledHosts = [ "nixi" ];
  
  # Verificar si el hostname actual está en la lista
  isEnabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf isEnabled {
    # Instalación a nivel sistema (opcional)
    environment.systemPackages = with pkgs; [
      obs-studio
    ];

    # Configuración de Home Manager
    home-manager.users.muere = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs                        # Captura de pantalla para Wayland
          obs-backgroundremoval         # Remover fondo con IA
          obs-pipewire-audio-capture    # Captura de audio con PipeWire
          obs-gstreamer                 # Soporte GStreamer
          obs-vkcapture                 # Captura Vulkan para juegos
        ];
      };
    };
  };
}
