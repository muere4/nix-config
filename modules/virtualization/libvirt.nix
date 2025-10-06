{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita
  userName = "muere";  # Usuario que tendrá acceso a libvirt

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar virtualización con libvirt
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };

    # Habilitar redirección USB con SPICE
    virtualisation.spiceUSBRedirection.enable = true;

    # Agregar usuario al grupo libvirtd
    users.groups.libvirtd.members = [ userName ];

    # Virt-Manager y herramientas relacionadas
    programs.virt-manager.enable = true;

    # Paquetes adicionales útiles
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
    ];
  };
}
