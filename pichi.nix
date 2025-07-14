{ config, pkgs, inputs, unstable, system, ... }:

let
  utils = import ./utils;
  load = f: import f { inherit config pkgs inputs unstable system utils; };

  # Función para cargar configuraciones (estilo Rebecca)
  cfg = p: utils.env.configOnlyEnvironment (import p);
  mkConfigs = cfgPaths:
    utils.env.concatEnvironments (builtins.map cfg cfgPaths);

  # Función para cargar imports (estilo Rebecca)
  mkImport = p: utils.env.importOnlyEnvironment (
    import p { inherit config pkgs inputs unstable system utils; }
  );
  mkImports = importPaths:
    utils.env.concatEnvironments (builtins.map mkImport importPaths);

  # Paquetes básicos usando tu sistema de collections existente
  systemDefaults = import ./collections/system-defaults.nix {
    inherit pkgs utils unstable;
    platform = "x86-64";
  };

  # Paquetes específicos de desarrollo
  devPackages = utils.env.packagesEnvironment (with pkgs; [
    vscode
  ]);

  # Navegadores
  browsers = utils.env.packagesEnvironment (with pkgs; [
    brave
    # Ejemplo de paquete del canal unstable:
    # unstable.discord
  ]);

  # Configuraciones usando mkImports para seguir el patrón de Rebecca
  configs = mkImports [
    ./configs/bash.nix
    ./configs/direnv.nix
    ./configs/git.nix
  ];

  # Ambiente completo combinando todo (estilo Rebecca)
  environment = utils.env.concatEnvironments [
    systemDefaults  # Ya incluye basicPackages y multimedia de collections/
    configs
    devPackages
    browsers
  ];

in {
  # Información básica del usuario
  home.username = "muere";
  home.homeDirectory = "/home/muere";

  # Versión de Home Manager
  home.stateVersion = "25.05";

  # Habilitar Home Manager para que se gestione a sí mismo
  programs.home-manager.enable = true;

  # Usar el sistema modular para imports y paquetes
  imports = environment.imports;
  home.packages = environment.packages;

  # Variables de entorno
  home.sessionVariables = {
    EDITOR = "kate";
    BROWSER = "microsoft-edge";
  };

  # XDG default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "microsoft-edge.desktop";
      "text/html" = "microsoft-edge.desktop";
      "text/xml" = "microsoft-edge.desktop";
      "x-scheme-handler/http" = "microsoft-edge.desktop";
      "x-scheme-handler/https" = "microsoft-edge.desktop";
      "x-scheme-handler/about" = "microsoft-edge.desktop";
      "x-scheme-handler/unknown" = "microsoft-edge.desktop";
    };
  };

  # Configuración de archivos de dotfiles (opcional)
  # home.file.".config/example/config.toml".text = ''
  #   # Contenido de configuración
  # '';
}
