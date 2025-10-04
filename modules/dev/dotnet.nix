{ config, pkgs, lib, ... }:

let
  # Configuración del módulo
  enabledHosts = [ "nixi" ];
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar nix-ld para que los binarios encuentren las librerías
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # Dependencias básicas
      stdenv.cc.cc.lib
      fontconfig
      freetype

      # OpenGL y gráficos
      libglvnd
      libGL

      # X11
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libICE
      xorg.libSM
      xorg.libXrandr
      xorg.libXrender
      xorg.libXext
      xorg.libXfixes

      # Wayland
      wayland

      # SkiaSharp dependencies
      skia
      harfbuzz
      libwebp
      libjpeg
      libpng
      zlib
    ];

    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      # .NET 8 SDK
      dotnet-sdk_8

      # OmniSharp para LSP (Emacs, VSCode, etc)
      omnisharp-roslyn

      # Herramientas de .NET
      dotnetPackages.Nuget
    ];

    # Variables de entorno globales para .NET
    environment.sessionVariables = {
      DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
    };

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes específicos del usuario
      home.packages = with pkgs; [
        # .NET SDK y herramientas
        dotnet-sdk_8
        omnisharp-roslyn
        dotnetPackages.Nuget

        # Dependencias de sistema para Avalonia UI (Linux)
        fontconfig
        libglvnd
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libICE
        xorg.libSM
        xorg.libXrandr
        libGL
        wayland  # Soporte Wayland para Avalonia

        # SkiaSharp dependencies
        skia
        harfbuzz
        libwebp
        libjpeg
        libpng
        zlib
      ];

      # Variables de entorno específicas del usuario
      home.sessionVariables = {
        DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";

        # Para Avalonia
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";
        AVALONIA_GLOBAL_SCALE_FACTOR = "1";

        # LD_LIBRARY_PATH para SkiaSharp y Avalonia
        LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.fontconfig
          pkgs.libglvnd
          pkgs.xorg.libX11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXi
          pkgs.xorg.libICE
          pkgs.xorg.libSM
          pkgs.xorg.libXrandr
          pkgs.libGL
          pkgs.wayland
          pkgs.skia
          pkgs.harfbuzz
          pkgs.libwebp
          pkgs.libjpeg
          pkgs.libpng
          pkgs.zlib
        ];
      };

      # Agregar librerías necesarias al LD_LIBRARY_PATH para Avalonia
      home.sessionPath = [
        "${pkgs.dotnet-sdk_8}/bin"
      ];

      # Aliases útiles para .NET
      programs.bash.shellAliases = {
        # .NET básico
        dn = "dotnet new";
        dr = "dotnet run";
        db = "dotnet build";
        dt = "dotnet test";
        dw = "dotnet watch run";

        # Web API
        dnapi = "dotnet new webapi -n";
        dnweb = "dotnet new web -n";

        # Avalonia
        dnavui = "dotnet new avalonia.mvvm -n";
        dnavapp = "dotnet new avalonia.app -n";

        # Gestión de paquetes
        dna = "dotnet add package";
        dnr = "dotnet remove package";
        dnl = "dotnet list package";

        # Limpieza
        dnclean = "dotnet clean && rm -rf bin obj";
      };

      programs.zsh.shellAliases = {
        # .NET básico
        dn = "dotnet new";
        dr = "dotnet run";
        db = "dotnet build";
        dt = "dotnet test";
        dw = "dotnet watch run";

        # Web API
        dnapi = "dotnet new webapi -n";
        dnweb = "dotnet new web -n";

        # Avalonia
        dnavui = "dotnet new avalonia.mvvm -n";
        dnavapp = "dotnet new avalonia.app -n";

        # Gestión de paquetes
        dna = "dotnet add package";
        dnr = "dotnet remove package";
        dnl = "dotnet list package";

        # Limpieza
        dnclean = "dotnet clean && rm -rf bin obj";
      };

      # Configuración de NuGet
      xdg.configFile."NuGet/NuGet.Config".text = ''
        <?xml version="1.0" encoding="utf-8"?>
        <configuration>
          <packageSources>
            <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
          </packageSources>
          <config>
            <add key="globalPackagesFolder" value="${config.xdg.cacheHome}/NuGet/packages" />
          </config>
        </configuration>
      '';

      # Script de inicialización para instalar templates de Avalonia
      home.activation.installAvaloniaTemplates = lib.mkAfter ''
        if ! ${pkgs.dotnet-sdk_8}/bin/dotnet new list | grep -q avalonia; then
          echo "📥 Instalando Avalonia templates..."
          ${pkgs.dotnet-sdk_8}/bin/dotnet new install Avalonia.Templates
        fi
      '';
    };
  };
}
