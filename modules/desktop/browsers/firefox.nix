{ config, pkgs, lib, ... }:

let
  # Configuración del módulo
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita Firefox
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Firefox a nivel sistema
    environment.systemPackages = with pkgs; [
      firefox
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, pkgs, ... }: {
      programs.firefox = {
        enable = true;


        profiles = {
          ${userName} = {
            id = 0;
            isDefault = true;


            settings = {
              # Configuración específica del perfil
              "browser.startup.homepage" = "about:home";
              "browser.newtabpage.enabled" = true;

              # Habilitar Sync
              "services.sync.engine.addons" = true;
              "services.sync.engine.prefs" = true;
              "services.sync.engine.bookmarks" = true;
              "services.sync.engine.history" = true;
              "services.sync.engine.tabs" = true;
              "services.sync.engine.passwords" = true;

              # Privacidad y seguridad
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "privacy.donottrackheader.enabled" = true;

              # Performance
              "browser.sessionstore.interval" = 15000000;
              "browser.cache.disk.enable" = true;
              "browser.cache.memory.enable" = true;

              # UI
              "browser.tabs.warnOnClose" = false;
              "browser.download.useDownloadDir" = true;
              "browser.download.dir" = "${config.home.homeDirectory}/Descargas";

              # Deshabilitar telemetría
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.archive.enabled" = false;

            };

            # Bookmarks declarativos
#             bookmarks = [
#               {
#                 name = "Desarrollo";
#                 toolbar = true;
#                 bookmarks = [
#                   {
#                     name = "GitHub";
#                     url = "https://github.com";
#                   }
#                   {
#                     name = "NixOS Search";
#                     url = "https://search.nixos.org";
#                   }
#                   {
#                     name = "Rust Docs";
#                     url = "https://doc.rust-lang.org";
#                   }
#                 ];
#               }
#               {
#                 name = "NixOS";
#                 toolbar = true;
#                 bookmarks = [
#                   {
#                     name = "NixOS Manual";
#                     url = "https://nixos.org/manual/nixos/stable";
#                   }
#                   {
#                     name = "Home Manager Options";
#                     url = "https://nix-community.github.io/home-manager/options.xhtml";
#                   }
#                 ];
#               }
#             ];

            # Motores de búsqueda
#             search = {
#               force = true;  # Forzar configuración declarativa
#               default = "DuckDuckGo";
#
#               engines = {
#                 "Nix Packages" = {
#                   urls = [{
#                     template = "https://search.nixos.org/packages";
#                     params = [
#                       { name = "type"; value = "packages"; }
#                       { name = "query"; value = "{searchTerms}"; }
#                     ];
#                   }];
#                   icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
#                   definedAliases = [ "@np" ];
#                 };
#
#                 "NixOS Options" = {
#                   urls = [{
#                     template = "https://search.nixos.org/options";
#                     params = [
#                       { name = "type"; value = "options"; }
#                       { name = "query"; value = "{searchTerms}"; }
#                     ];
#                   }];
#                   icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
#                   definedAliases = [ "@no" ];
#                 };
#
#                 "Home Manager Options" = {
#                   urls = [{
#                     template = "https://mipmip.github.io/home-manager-option-search/";
#                     params = [
#                       { name = "query"; value = "{searchTerms}"; }
#                     ];
#                   }];
#                   definedAliases = [ "@hm" ];
#                 };
#
#                 "GitHub" = {
#                   urls = [{
#                     template = "https://github.com/search";
#                     params = [
#                       { name = "q"; value = "{searchTerms}"; }
#                     ];
#                   }];
#                   definedAliases = [ "@gh" ];
#                 };
#
#                 # Deshabilitar motores que no uses
#                 "Google".metaData.hidden = true;
#                 "Amazon.com".metaData.hidden = true;
#                 "Bing".metaData.hidden = true;
#               };
#             };

            # User.js personalizado (configuración avanzada)
#             extraConfig = ''
#               // Configuración adicional de uBlock Origin
#               user_pref("extensions.webextensions.ExtensionStorageIDB.migrated.uBlock0@raymondhill.net", true);
#
#               // Habilitar userChrome.css
#               user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
#
#               // Smooth scrolling
#               user_pref("general.smoothScroll", true);
#               user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 250);
#               user_pref("general.smoothScroll.mouseWheel.durationMinMS", 125);
#             '';

          };
        };
      };

      # Configuración de XDG para hacer Firefox el navegador por defecto
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        };
      };

    };
  };
}
