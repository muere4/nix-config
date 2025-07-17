{ pkgs
, utils
, userDefinedExtensions ? (vscode-extensions: [])
, extraSettings ? {}
, vscodePackage ? pkgs.vscode
, createDesktopEntry ? true
, ...}:

let
  # Configuración de fonts (CORREGIDO para Home Manager)
  firaCodeFonts = {
    home.packages = with pkgs; [
      fira-code
      fira-code-symbols
    ];
  };

  # Configuración del desktop entry si se requiere
#   desktopEntry =
#     if createDesktopEntry
#     then {
#       xdg.desktopEntries.vscode = {
#         name = "Visual Studio Code";
#         comment = "Code Editing. Redefined.";
#         exec = "${vscodePackage}/bin/code";
#         icon = "vscode";
#         startupNotify = true;
#         categories = [ "Development" "IDE" ];
#       };
#     }
#     else {};

  # Configuración base de VS Code
  vscodeConfig = {
    programs.vscode = {
      enable = true;
      # Usar FHS para mejor compatibilidad con extensiones .NET
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [
        # Dependencias específicas para .NET development
        dotnet-sdk_8
        dotnet-runtime_8

        # Herramientas para Haskell
        ghc
        cabal-install
        stack

        # Herramientas generales útiles
        git
        curl
        wget
      ]);

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Extensiones para Haskell
          haskell.haskell
          justusadam.language-haskell

          # Extensiones para C# y F#
          ms-dotnettools.csharp
          ms-dotnettools.vscode-dotnet-runtime
          ionide.ionide-fsharp

          # Extensiones básicas útiles
          ms-vscode.hexeditor

          # Git básico
          github.vscode-pull-request-github

        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          # Shades of Purple theme desde marketplace
          {
            name = "shades-of-purple";
            publisher = "ahmadawais";
            version = "6.13.0";
            sha256 = "01kr8kph3r5rxds6nnz07nssyqwkcygg0jr7yvbr1mg4irwcpjhd";
          }

        ] ++ userDefinedExtensions pkgs.vscode-extensions;

        # Configuración de usuario
        userSettings = {
          # Configuración de Fira Code
          "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', monospace";
          "editor.fontSize" = 14;
          "editor.fontLigatures" = true;
          "editor.fontWeight" = "normal";

          # Tema Shades of Purple
          "workbench.colorTheme" = "Shades of Purple";
          "workbench.iconTheme" = "shades-of-purple-icons";

          # Configuración del editor
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.renderWhitespace" = "boundary";
          "editor.rulers" = [ 80 120 ];
          "editor.wordWrap" = "bounded";
          "editor.wordWrapColumn" = 120;

          # Configuración específica para Haskell
          "[haskell]" = {
            "editor.tabSize" = 2;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
          };

          # Configuración específica para C#
          "[csharp]" = {
            "editor.tabSize" = 4;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
          };

          # Configuración específica para F#
          "[fsharp]" = {
            "editor.tabSize" = 4;
            "editor.insertSpaces" = true;
            "editor.formatOnSave" = true;
          };

          # Configuración de .NET
          "dotnet.completion.showCompletionItemsFromUnimportedNamespaces" = true;
          "dotnet.inlayHints.enableInlayHintsForParameters" = true;
          "dotnet.inlayHints.enableInlayHintsForLiteralParameters" = true;
          "dotnet.inlayHints.enableInlayHintsForObjectCreationParameters" = true;

          # Configuración de Haskell Language Server
          "haskell.manageHLS" = "GHCup";
          "haskell.serverEnvironment" = "system";
          "haskell.formattingProvider" = "ormolu";

          # Configuración de F# (Ionide)
          "FSharp.inlayHints.enabled" = true;
          "FSharp.inlayHints.typeAnnotations" = true;
          "FSharp.inlayHints.parameterNames" = true;

          # Configuración general
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "explorer.confirmDelete" = false;
          "workbench.editor.enablePreview" = false;
          "terminal.integrated.fontFamily" = "Fira Code";
          "terminal.integrated.fontSize" = 13;

          # Fusionar configuraciones adicionales
        } // extraSettings;

        # Keybindings básicos
        keybindings = [
          {
            key = "ctrl+shift+t";
            command = "workbench.action.terminal.new";
          }
          {
            key = "ctrl+shift+`";
            command = "workbench.action.terminal.toggleTerminal";
          }
          {
            key = "ctrl+shift+p";
            command = "workbench.action.showCommands";
          }
        ];
      };
    };
  };

  # Configuración para Wayland si es necesario (CORREGIDO)
  waylandSupport = {
    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  # Servicios adicionales necesarios - REMOVIDO porque son opciones del sistema
  # additionalServices = {
  #   # Para autenticación de extensiones
  #   services.gnome.gnome-keyring.enable = true;
  #
  #   # Para Remote SSH si decides usarlo después
  #   programs.nix-ld.enable = true;
  # };

  # Combinar todas las configuraciones
  allConfigs = firaCodeFonts // vscodeConfig // waylandSupport; #// desktopEntry;

in
utils.env.importOnlyEnvironment allConfigs
