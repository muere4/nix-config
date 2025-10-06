{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      emacs
      git
    ];

    home-manager.users.${userName} = { config, ... }: {
      # Solo agregar bin al PATH, Doom usa defaults
      home.sessionPath = [ "$HOME/.config/emacs/bin" ];

      home.packages = with pkgs; [
        # Core dependencies
        git
        ripgrep
        fd
        coreutils
        clang

        # Build tools para vterm
        cmake
        gnumake
        libtool

        # Utilidades
        shellcheck
        pandoc
        graphviz
        sqlite-interactive
        nixfmt-classic

        # Fuentes
        emacs-all-the-icons-fonts
        fontconfig
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.droid-sans-mono
        nerd-fonts.symbols-only

        # Emacs packages (para vterm, pdf, etc)
        emacsPackages.vterm
        emacsPackages.pdf-tools
        emacsPackages.omnisharp
      ];

      fonts.fontconfig.enable = true;

      programs.emacs = {
        enable = true;
        package = pkgs.emacs;
      };

      # Solo aliases útiles
      programs.bash.shellAliases = {
        doom = "~/.config/emacs/bin/doom";
        doom-sync = "~/.config/emacs/bin/doom sync";
        doom-doctor = "~/.config/emacs/bin/doom doctor";
        doom-setup = "~/nix-config/config/emacs/doom-setup.sh";
        # Aliases de conveniencia como hlissner
        e = "emacsclient -n";
        ekill = "emacsclient --eval '(kill-emacs)'";
      };
    };
  };
}
