{ config, pkgs, ... }:
{
  imports = [
    ../../modules/dev
    ../../modules/desktop
    ../../modules/editors
    ../../modules/virtualization
    ../../modules/packages
  ];

  # Configuración básica del host
  networking.hostName = "nixi";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/Argentina/Buenos_Aires";
  i18n.defaultLocale = "es_AR.UTF-8";

  i18n.extraLocaleSettings = {
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


  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  console.keyMap = "es";


  #services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Usuario
  users.users.muere = {
    isNormalUser = true;
    description = "muere";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Paquetes básicos del sistema
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop

    libreoffice-fresh
    ntfs3g
    p7zip
    qbittorrent
  ];

  # Habilitar flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.spice-vdagentd.enable = true;

  system.stateVersion = "25.05";
}
