{ config, lib, pkgs, ... }:
let
  # Lista de hosts donde quieres habilitar OBS
  enabledHosts = [ "nixi" ];
  
  # Verificar si el hostname actual está en la lista
  isEnabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf isEnabled {
    # Habilitar cámara virtual para OBS y Droidcam
    programs.obs-studio.enableVirtualCamera = true;
    
    # Habilitar Droidcam
    programs.droidcam.enable = true;
    
    # Configuración de Home Manager
    home-manager.users.muere = {
      programs.obs-studio = {
        enable = true;
        
        # Aceleración de hardware para Intel
#         package = pkgs.obs-studio.override {
#            waylandSupport = true;  # Si usas Wayland
#         };
        
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs                        # Captura de pantalla para Wayland
          obs-backgroundremoval         # Remover fondo con IA
          obs-pipewire-audio-capture    # Captura de audio con PipeWire
          obs-vaapi                     # Aceleración hardware Intel (VA-API)
          obs-gstreamer                 # Soporte GStreamer
          obs-vkcapture                 # Captura Vulkan para juegos
          droidcam-obs
        ];
      };
    };
  };
}
