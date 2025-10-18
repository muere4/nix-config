{ config, pkgs, ... }:
{
  imports = [
    ../../modules/dev
    ../../modules/desktop
    ../../modules/editors
    ../../modules/virtualization
    ../../modules/packages
    ../../modules/services
    ../../modules/games
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

  # firewall?





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

  nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"  # Community
  ];

  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};

  # Habilitar flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.spice-vdagentd.enable = true;

  system.stateVersion = "25.05";
}
