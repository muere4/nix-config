{ config, pkgs, lib, ... }:

let
  # Hosts en los que este módulo estará habilitado
  enabledHosts = [ "nixos" "nixi" ];
  userName = "muere";

  # Detectar si este host está habilitado
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar Samba
    services.samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "NixOS Media Server";
          "netbios name" = config.networking.hostName;
          security = "user";
          "server min protocol" = "SMB2";
          "map to guest" = "bad user";
        };

        videos = {
          path = "/home/${userName}/Vídeos";
          browseable = "yes";
          "read only" = "yes";
          "guest ok" = "yes";
          comment = "Videos compartidos";
        };

        # Puedes agregar más carpetas si quieres
        # descargas = {
        #   path = "/home/${userName}/Downloads";
        #   browseable = "yes";
        #   "read only" = "yes";
        #   "guest ok" = "yes";
        #   comment = "Descargas compartidas";
        # };
      };
    };

    # Asegurar que los puertos estén abiertos (redundante con openFirewall pero explícito)
    networking.firewall = {
      allowedTCPPorts = [ 139 445 ];
      allowedUDPPorts = [ 137 138 ];
    };

    # Servicios relacionados que pueden ser útiles
    services.samba-wsdd = {
      enable = true;  # Permite descubrimiento en Windows
      openFirewall = true;
    };
  };
}
