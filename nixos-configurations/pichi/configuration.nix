# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, inputs, unstable, ... }:

{
  # Habilitar funciones experimentales de Nix
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    # Incluir los resultados del escaneo de hardware
    ./hardware-configuration.nix
  ];

  # Configuración del bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configuración de red
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # networking.wireless.enable = true;  # Habilita soporte wireless via wpa_supplicant
    # networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  # Configuración de zona horaria
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Configuración de idioma e internacionalización
  i18n = {
    defaultLocale = "es_AR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };
  };

  # Configuración del servidor X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "es";
      variant = "";
    };
  };

  # Configuración del display manager y entorno de escritorio
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configuración de keymap de consola
  console.keyMap = "es";

  # Servicios habilitados
  services = {
    printing.enable = true;
    pulseaudio.enable = false;
    # Habilitar touchpad support (enabled default in most desktopManager)
    # xserver.libinput.enable = true;
  };

  # Configuración de audio con PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Si quieres usar aplicaciones JACK, descomenta esto
    # jack.enable = true;
  };

  # Configuración de usuarios
  users.users.muere = {
    isNormalUser = true;
    description = "muere";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      # Ejemplo de paquete del canal unstable:
      # unstable.discord
      # thunderbird
    ];
  };

  # Configuración de programas
  programs.firefox.enable = true;

  # Variables de entorno
  environment.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.microsoft-edge}/bin/microsoft-edge";
  };

  # Configuración de paquetes
  nixpkgs.config.allowUnfree = true;

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    # Editores y herramientas básicas
    vim
    wget
    git

    # Navegadores
    microsoft-edge

    # Ejemplo de cómo usar paquetes del canal unstable:
    # unstable.neovim
  ];

  # Configuración XDG para aplicaciones por defecto
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "microsoft-edge.desktop";
      "text/html" = "microsoft-edge.desktop";
      "x-scheme-handler/http" = "microsoft-edge.desktop";
      "x-scheme-handler/https" = "microsoft-edge.desktop";
      "x-scheme-handler/about" = "microsoft-edge.desktop";
      "x-scheme-handler/unknown" = "microsoft-edge.desktop";
    };
  };

  # Configuración de programas adicionales
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Configuración de servicios de red
  # services.openssh.enable = true;

  # Configuración de firewall
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # O deshabilitar el firewall completamente:
  # networking.firewall.enable = false;

  # Este valor determina la versión de NixOS desde la cual se tomaron
  # las configuraciones por defecto para datos con estado, como ubicaciones
  # de archivos y versiones de base de datos en tu sistema. Es perfectamente
  # correcto y recomendado dejar este valor en la versión de lanzamiento
  # de la primera instalación de este sistema.
  # Antes de cambiar este valor lee la documentación para esta opción
  # (ej. man configuration.nix o en https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # ¿Leíste el comentario?

}
