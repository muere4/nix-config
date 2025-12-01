{ config, pkgs, lib, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    
    virtualisation.spiceUSBRedirection.enable = true;
    users.groups.libvirtd.members = [ userName ];
    programs.virt-manager.enable = true;
    services.spice-vdagentd.enable = true;
    
    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
    ];
  };
}
