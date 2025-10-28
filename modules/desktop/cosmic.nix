{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita COSMIC
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar el entorno de escritorio COSMIC
    services.desktopManager.cosmic.enable = true;

    # Habilitar el gestor de inicio de sesión COSMIC (opcional)
    # Si no lo habilitas, puedes usar SDDM, GDM u otro display manager
    services.displayManager.cosmic-greeter.enable = true;

    # Configurar inicio de sesión automático (opcional)
    # services.displayManager.autoLogin = {
    #   enable = true;
    #   user = userName;
    # };

    # Excluir aplicaciones COSMIC que no quieras (solo en NixOS 25.11+)
    # environment.cosmic.excludePackages = with pkgs; [
    #   cosmic-edit
    # ];

    # Variables de entorno para COSMIC
    environment.sessionVariables = {
      # Habilitar protocolo zwlr_data_control_manager_v1 para clipboard managers
      # ADVERTENCIA: Esto permite que todas las ventanas accedan al portapapeles
      # COSMIC_DATA_CONTROL_ENABLED = "1";
    };

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes adicionales para COSMIC (opcional)
      home.packages = with pkgs; [
        # Herramientas útiles para Wayland/COSMIC
        wl-clipboard
        cliphist  # Gestor de historial del portapapeles para Wayland
      ];

      # Configuración de Firefox para temas COSMIC (opcional)
      programs.firefox.profiles.${userName} = {
        settings = {
          # Deshabilitar libadwaita theming para que Firefox use temas de COSMIC
          "widget.gtk.libadwaita-colors.enabled" = false;
        };
      };

      # Aliases útiles para COSMIC
      programs.bash.shellAliases = {
        cosmic-settings = "cosmic-settings";
        cosmic-restart = "systemctl restart --user cosmic-session.target";
      };

      programs.zsh.shellAliases = {
        cosmic-settings = "cosmic-settings";
        cosmic-restart = "systemctl restart --user cosmic-session.target";
      };
    };
  };
}
