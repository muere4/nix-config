{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      vscode-fhs
    ];

    home-manager.users.${userName} = {
      home.packages = with pkgs; [
        vscode-fhs

        # Herramientas útiles para desarrollo que VSCode puede usar
        # nodejs_20
        # nodePackages.npm
        # nodePackages.yarn

        # LSP servers y herramientas de lenguajes
        # nodePackages.typescript
        # nodePackages.typescript-language-server
        # nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
        # nodePackages.yaml-language-server

        # Formatters
        # nodePackages.prettier

        # Git
        # git
        # gh  # GitHub CLI
      ];

      programs.vscode = {
        enable = true;
        package = pkgs.vscode-fhs;

        extensions = with pkgs.vscode-extensions; [
          catppuccin.catppuccin-vsc
        ];

        # Configuración de VSCode (settings.json)
        # userSettings = {
        #   # Editor
        #   "editor.fontSize" = 14;
        #   "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'FiraCode Nerd Font', 'Droid Sans Mono', monospace";
        #   "editor.fontLigatures" = true;
        #   "editor.lineNumbers" = "on";
        #   "editor.rulers" = [ 80 120 ];
        #   "editor.wordWrap" = "on";
        #   "editor.minimap.enabled" = true;
        #   "editor.cursorBlinking" = "smooth";
        #   "editor.cursorSmoothCaretAnimation" = "on";
        #   "editor.smoothScrolling" = true;
        #   "editor.formatOnSave" = true;
        #   "editor.formatOnPaste" = true;
        #   "editor.tabSize" = 2;
        #   "editor.insertSpaces" = true;
        #   "editor.detectIndentation" = true;
        #   "editor.bracketPairColorization.enabled" = true;
        #   "editor.guides.bracketPairs" = true;
        #   "editor.inlineSuggest.enabled" = true;
        #   "editor.suggestSelection" = "first";
        #   "editor.acceptSuggestionOnCommitCharacter" = false;
        #
        #   # Workbench
        #   "workbench.colorTheme" = "Catppuccin Mocha";
        #   "workbench.iconTheme" = "catppuccin-mocha";
        #   "workbench.startupEditor" = "none";
        #   "workbench.editor.enablePreview" = false;
        #   "workbench.editor.closeOnFileDelete" = true;
        #
        #   # Terminal
        #   "terminal.integrated.fontSize" = 13;
        #   "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
        #   "terminal.integrated.cursorBlinking" = true;
        #   "terminal.integrated.defaultProfile.linux" = "bash";
        #
        #   # Files
        #   "files.autoSave" = "afterDelay";
        #   "files.autoSaveDelay" = 1000;
        #   "files.trimTrailingWhitespace" = true;
        #   "files.insertFinalNewline" = true;
        #   "files.exclude" = {
        #     "**/.git" = true;
        #     "**/.svn" = true;
        #     "**/.hg" = true;
        #     "**/CVS" = true;
        #     "**/.DS_Store" = true;
        #     "**/Thumbs.db" = true;
        #     "**/.direnv" = true;
        #     "**/.devenv" = true;
        #     "**/result" = true;
        #   };
        #
        #   # Git
        #   "git.enableSmartCommit" = true;
        #   "git.confirmSync" = false;
        #   "git.autofetch" = true;
        #
        #   # Nix
        #   "nix.enableLanguageServer" = true;
        #   "nix.serverPath" = "nil";
        #   "nix.serverSettings" = {
        #     "nil" = {
        #       "formatting" = {
        #         "command" = [ "nixfmt" ];
        #       };
        #     };
        #   };
        #
        #   # Python
        #   "python.languageServer" = "Pylance";
        #   "python.formatting.provider" = "black";
        #   "python.linting.enabled" = true;
        #   "python.linting.pylintEnabled" = true;
        #
        #   # C#/.NET
        #   "omnisharp.useModernNet" = true;
        #   "omnisharp.enableEditorConfigSupport" = true;
        #   "omnisharp.enableRoslynAnalyzers" = true;
        #
        #   # Rust
        #   "rust-analyzer.check.command" = "clippy";
        #   "rust-analyzer.cargo.features" = "all";
        #
        #   # Formatters
        #   "prettier.semi" = true;
        #   "prettier.singleQuote" = true;
        #   "prettier.trailingComma" = "es5";
        #
        #   # Extensiones
        #   "extensions.autoUpdate" = false;
        #   "extensions.autoCheckUpdates" = false;
        #
        #   # Telemetry (deshabilitada)
        #   "telemetry.telemetryLevel" = "off";
        #   "redhat.telemetry.enabled" = false;
        # };

        # Keybindings personalizados (keybindings.json)
        # keybindings = [
        #   {
        #     key = "ctrl+shift+f";
        #     command = "workbench.action.findInFiles";
        #   }
        #   {
        #     key = "ctrl+`";
        #     command = "workbench.action.terminal.toggleTerminal";
        #   }
        # ];
      };

      # Aliases útiles para VSCode
      # programs.bash.shellAliases = {
      #   code = "code";
      #   c = "code .";
      #   code-extensions = "code --list-extensions";
      #   code-insiders = "code-insiders";
      # };

      home.sessionVariables = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      # Crear carpeta de snippets personalizada
      # xdg.configFile."Code/User/snippets/.gitkeep".text = "";
    };
  };
}
