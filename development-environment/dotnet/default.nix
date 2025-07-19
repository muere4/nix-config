{ pkgs
, utils
, extraPackages ? []
, enableWorkloads ? true
, ...
}:

let
  # Combinar múltiples SDKs de .NET como se muestra en el foro
  dotnet-combined = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_9_0  # .NET 9
    sdk_8_0  # .NET 8
    aspnetcore_8_0
    aspnetcore_9_0
  ]).overrideAttrs (finalAttrs: previousAttrs:
    # Solo aplicar el override si queremos habilitar workloads
    if enableWorkloads then {
      # Necesario para instalar workloads en $HOME en lugar de store readonly
      postBuild = (previousAttrs.postBuild or "") + ''
        for i in $out/sdk/*
        do
          i=$(basename $i)
          mkdir -p $out/metadata/workloads/''${i/-*}
          touch $out/metadata/workloads/''${i/-*}/userlocal
        done
      '';
    } else {});

  # Herramientas adicionales para desarrollo .NET
  dotnetTools = with pkgs; [
    # Herramientas de desarrollo
    dotnet-ef                    # Entity Framework CLI
    # Herramientas de análisis y formato
    omnisharp-roslyn            # Language server para C#
    # Herramientas opcionales que podrías necesitar
    nuget-to-nix                # Para convertir paquetes NuGet
  ];

in
{
  packages = [ dotnet-combined ] ++ dotnetTools ++ extraPackages;

  imports = [];

  # Configuración específica para Neovim
  emacsExtraPackages = (epkgs: []);  # No usamos Emacs para .NET

  emacsExtraConfig = "";

  # Variables de entorno necesarias para .NET
  sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";
    # Opcional: deshabilitar telemetría
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    # Configurar ubicación de herramientas globales
    DOTNET_TOOLS_PATH = "$HOME/.dotnet/tools";
  };

  # Configuración adicional que se podría necesitar
  extraConfig = {
    # Agregar herramientas .NET al PATH
    home.sessionPath = [ "$HOME/.dotnet/tools" ];

    # Configuración para desarrollo con containers (opcional)
    # programs.docker.enable = true;
  };
}
