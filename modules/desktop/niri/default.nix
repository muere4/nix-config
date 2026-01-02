{ config, pkgs, lib, inputs, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  imports = [
    inputs.dms.nixosModules.greeter  # ← AGREGA ESTO
  ];

  config = lib.mkIf enabled {
    # Sistema
    programs.niri = {
      enable = true;
      package = pkgs.unstable.niri;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # DankGreeter reemplaza a SDDM
    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/${userName}";  # Sincroniza tema con tu usuario
    };

    # DESACTIVA SDDM (DankGreeter lo reemplaza)
    # services.displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };

    networking.networkmanager.enable = true;
    services.upower.enable = true;
    security.polkit.enable = true;

    # Usuario
    home-manager.users.${userName} = {
      programs.dankMaterialShell = {
        enable = true;
        systemd.enable = true;

        enableSystemMonitoring = true;
        enableClipboard = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;

        default.settings = {
          theme = "dark";
          dynamicTheming = true;
        };
      };

      # Archivos de configuración de niri
      home.file = {
        ".config/niri/config.kdl".source = ./config.kdl;
        ".config/niri/custom-binds.kdl".source = ./custom-binds.kdl;

        # Crear archivos vacíos para DMS auto-configuración
        ".config/niri/dms/colors.kdl".text = "// Auto-generado por DMS";
        ".config/niri/dms/layout.kdl".text = "// Auto-generado por DMS";
        ".config/niri/dms/alttab.kdl".text = "// Auto-generado por DMS";
        ".config/niri/dms/binds.kdl".text = "// Auto-generado por DMS";
      };

      home.packages = with pkgs; [
        alacritty
        kdePackages.kate
        kdePackages.dolphin
        kdePackages.okular
        kdePackages.ark
        kdePackages.gwenview
        xwayland-satellite

        pavucontrol  # Control de audio
        networkmanagerapplet  # WiFi GUI
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {


          # File Manager - Dolphin
          "inode/directory" = "org.kde.dolphin.desktop";

          # Editor de texto - Kate (todos los archivos de texto)
          "text/plain" = "org.kde.kate.desktop";
          "text/x-nix" = "org.kde.kate.desktop";
          "text/x-python" = "org.kde.kate.desktop";
          "text/x-shellscript" = "org.kde.kate.desktop";
          "text/x-csrc" = "org.kde.kate.desktop";
          "text/x-c++src" = "org.kde.kate.desktop";
          "text/x-chdr" = "org.kde.kate.desktop";
          "text/x-c++hdr" = "org.kde.kate.desktop";
          "text/x-java" = "org.kde.kate.desktop";
          "text/javascript" = "org.kde.kate.desktop";
          "text/css" = "org.kde.kate.desktop";
          "text/xml" = "org.kde.kate.desktop";
          "text/markdown" = "org.kde.kate.desktop";
          "text/x-rust" = "org.kde.kate.desktop";
          "text/x-go" = "org.kde.kate.desktop";
          "application/json" = "org.kde.kate.desktop";
          "application/x-yaml" = "org.kde.kate.desktop";
          "application/xml" = "org.kde.kate.desktop";
          "application/toml" = "org.kde.kate.desktop";

          # PDFs
          "application/pdf" = "org.kde.okular.desktop";

        };
      };

    };
  };
}
