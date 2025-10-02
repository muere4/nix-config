{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita Podman
  
  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar contenedores
    virtualisation.containers.enable = true;
    
    virtualisation.podman = {
      enable = true;
      
      # Crear alias 'docker' para podman (drop-in replacement)
      dockerCompat = true;
      
      # Necesario para que los contenedores puedan comunicarse entre sí
      defaultNetwork.settings.dns_enabled = true;
      
      # Opcional: habilitar socket de Docker para compatibilidad
      # dockerSocket.enable = true;
      
      # Opcional: auto-actualizar imágenes
      # autoPrune.enable = true;
    };

    # Agregar tu usuario al grupo podman
    users.users.muere.extraGroups = [ "podman" ];

    # Paquetes relacionados con Podman
    environment.systemPackages = with pkgs; [
      podman-compose       # Docker Compose para Podman
      podman-tui          # TUI para gestionar contenedores
      dive              # Explorar capas de imágenes
      distrobox
      # buildah           # Construir imágenes OCI
      # skopeo            # Trabajar con imágenes de contenedores
    ];
  };
}
