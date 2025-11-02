{ config, pkgs, lib, ... }:

let
  # Configuración del módulo
  enabledHosts = [ "nixi" ];
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;

  # Combinar múltiples SDKs con soporte para workloads locales
  dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_9_0
    sdk_8_0
  ]).overrideAttrs (finalAttrs: previousAttrs: {
    # Esto permite instalar workloads en $HOME en lugar del store de Nix
    # Necesario para MAUI, Blazor Hybrid, etc.
    # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2
    postBuild = (previousAttrs.postBuild or "") + ''
      for i in $out/sdk/*
      do
        i=$(basename $i)
        mkdir -p $out/metadata/workloads/''${i/-*}
        touch $out/metadata/workloads/''${i/-*}/userlocal
      done
    '';
  });

  # Rider en modo FHS para mejor compatibilidad
  rider-fhs = pkgs.buildFHSEnv {
    name = "rider";
    targetPkgs = pkgs: (with pkgs; [
      # .NET combinado con soporte para workloads
      dotnet-combined
      #jetbrains.rider

      # Runtimes adicionales
      dotnetCorePackages.aspnetcore_8_0
      dotnetCorePackages.aspnetcore_9_0

      # Herramientas
      powershell
      git

      # Dependencias comunes
      icu
      openssl
      zlib
      krb5
    ]);

    runScript = "${pkgs.jetbrains.rider}/bin/rider";

    # Variables de entorno para Rider
    profile = ''
      export DOTNET_ROOT="${dotnet-combined}"
      export DOTNET_CLI_TELEMETRY_OPTOUT="1"
      export DOTNET_SKIP_FIRST_TIME_EXPERIENCE="1"
    '';
  };
in
{
  config = lib.mkIf enabled {
    # Habilitar nix-ld para que los binarios encuentren las librerías
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # Dependencias básicas del runtime
      stdenv.cc.cc.lib
      fontconfig
      freetype
      icu
      openssl
      zlib
      krb5

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

      # SkiaSharp dependencies (para Avalonia)
      skia
      harfbuzz
      libwebp
      libjpeg
      libpng

      # Multimedia (para apps con media)
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ];

    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      # .NET combinado con soporte para workloads locales
      dotnet-combined

      # Rider en modo FHS
      rider-fhs

      # OmniSharp para LSP (Emacs, VSCode, etc)
      omnisharp-roslyn

      # Herramientas de .NET
      dotnetPackages.Nuget

      # PowerShell (útil para scripts)
      powershell
    ];

    # Variables de entorno globales para .NET
    environment.sessionVariables = {
      # Usar el SDK combinado
      DOTNET_ROOT = "${dotnet-combined}";

      # Deshabilitar telemetría
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";

      # Optimizaciones de performance
      DOTNET_TieredPGO = "1";  # Profile-Guided Optimization
      DOTNET_TC_QuickJitForLoops = "1";  # QuickJIT para loops
      DOTNET_ReadyToRun = "1";  # Usar imágenes ReadyToRun cuando estén disponibles

      # Garbage Collection optimizado
      DOTNET_gcServer = "1";  # Usar GC de servidor (mejor para multi-core)
      DOTNET_GCConserveMemory = "2";  # Balance entre memoria y performance

      # Para desarrollo más rápido
      DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER = "1";
    };

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes específicos del usuario
      home.packages = with pkgs; [
        # .NET combinado con soporte para workloads
        dotnet-combined

        # Herramientas
        omnisharp-roslyn
        dotnetPackages.Nuget
        powershell

        # Rider FHS
        rider-fhs

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
        wayland

        # SkiaSharp dependencies
        skia
        harfbuzz
        libwebp
        libjpeg
        libpng
        zlib

        # ICU para globalización
        icu
      ];

      # Variables de entorno específicas del usuario
      home.sessionVariables = {
        DOTNET_ROOT = "${dotnet-combined}";
        DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";

        # Optimizaciones de performance
        DOTNET_TieredPGO = "1";
        DOTNET_TC_QuickJitForLoops = "1";
        DOTNET_ReadyToRun = "1";
        DOTNET_gcServer = "1";
        DOTNET_GCConserveMemory = "2";

        # Para Avalonia
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "0";
        AVALONIA_GLOBAL_SCALE_FACTOR = "1";

        # Hot Reload mejorado
        DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER = "1";
        DOTNET_WATCH_RESTART_ON_RUDE_EDIT = "1";

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
          pkgs.icu
          pkgs.openssl
          pkgs.krb5
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
        ];
      };

      # Agregar SDKs al PATH
      home.sessionPath = [
        "${dotnet-combined}/bin"
      ];

      # Aliases útiles para .NET
      programs.bash.shellAliases = {
        # .NET básico
        dn = "dotnet new";
        dr = "dotnet run";
        db = "dotnet build";
        dt = "dotnet test";
        dw = "dotnet watch run";
        dp = "dotnet publish -c Release";

        # Web API y Blazor
        dnapi = "dotnet new webapi -n";
        dnweb = "dotnet new web -n";
        dnblazor = "dotnet new blazor -n";
        dnminimal = "dotnet new webapi --use-minimal-apis -n";

        # Avalonia
        dnavui = "dotnet new avalonia.mvvm -n";
        dnavapp = "dotnet new avalonia.app -n";

        # MAUI (si se necesita)
        dnmaui = "dotnet new maui -n";

        # Gestión de paquetes
        dna = "dotnet add package";
        dnr = "dotnet remove package";
        dnl = "dotnet list package";
        dnoutdated = "dotnet list package --outdated";
        dnvulnerable = "dotnet list package --vulnerable";

        # Limpieza profunda
        dnclean = "dotnet clean && rm -rf bin obj";
        dnrealclean = "find . -iname 'bin' -o -iname 'obj' | xargs rm -rf";

        # NuGet cache
        dncleancache = "dotnet nuget locals all --clear";

        # Información y diagnóstico
        dninfo = "dotnet --info";
        dnsdk = "dotnet --list-sdks";
        dnruntime = "dotnet --list-runtimes";

        # Rider FHS
        rider = "rider-fhs";
      };



      # Configuración de NuGet optimizada
      xdg.configFile."NuGet/NuGet.Config".text = ''
        <?xml version="1.0" encoding="utf-8"?>
        <configuration>
          <packageSources>
            <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
          </packageSources>
          <config>
            <add key="globalPackagesFolder" value="${config.xdg.cacheHome}/NuGet/packages" />
            <add key="repositoryPath" value="${config.xdg.cacheHome}/NuGet/packages" />
            <add key="http_proxy" value="" />
            <add key="http_proxy.user" value="" />
            <add key="http_proxy.password" value="" />
          </config>
          <packageRestore>
            <add key="enabled" value="True" />
            <add key="automatic" value="True" />
          </packageRestore>
        </configuration>
      '';

      # global.json para proyectos que necesiten .NET 8 específicamente
      home.file.".dotnet/global.json".text = builtins.toJSON {
        sdk = {
          version = "9.0.0";
          rollForward = "latestMinor";
          allowPrerelease = false;
        };
      };

      # Script de inicialización para instalar templates
      home.activation.installDotnetTemplates = lib.mkAfter ''
        # Avalonia templates
        if ! ${dotnet-combined}/bin/dotnet new list | grep -q avalonia; then
          echo "📥 Instalando Avalonia templates..."
          ${dotnet-combined}/bin/dotnet new install Avalonia.Templates
        fi

        # MAUI templates (opcional, descomenta si lo necesitas)
        # if ! ${dotnet-combined}/bin/dotnet new list | grep -q maui; then
        #   echo "📥 Instalando MAUI templates..."
        #   ${dotnet-combined}/bin/dotnet new install Microsoft.Maui.Templates
        # fi

        # Blazor templates adicionales (opcional)
        # if ! ${dotnet-combined}/bin/dotnet new list | grep -q blazorwasm; then
        #   echo "📥 Instalando Blazor templates..."
        #   ${dotnet-combined}/bin/dotnet new install Microsoft.AspNetCore.Blazor.Templates
        # fi
      '';

      # Nota sobre instalación de workloads:
      # Gracias al parche 'userlocal', ahora podés instalar workloads normalmente:
      #
      # Para MAUI:
      #   dotnet workload install maui
      #
      # Para Blazor Hybrid:
      #   dotnet workload install maui-blazor
      #
      # Para WebAssembly:
      #   dotnet workload install wasm-tools
      #
      # Para Android:
      #   dotnet workload install android
      #
      # Para iOS (requiere macOS):
      #   dotnet workload install ios
      #
      # Los workloads se instalarán en:
      #   ~/.dotnet/sdk/<version>/
      #
      # Para ver workloads instalados:
      #   dotnet workload list
      #
      # Para actualizar workloads:
      #   dotnet workload update
    };
  };
}
