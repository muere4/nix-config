# Después del primer rebuild

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
doom install

cp -v ~/nix-config/doom/* ~/.config/doom/

doom sync



1.
ls -la ~/.ssh/
# Ver clave pública de muere4
cat ~/.ssh/github_muere4.pub
# Ver clave pública de facusmzi
cat ~/.ssh/github_facusmzi.pub

2. Agregar clave de muere4 a GitHub
1. Copia el contenido de ~/.ssh/github_muere4.pub
2. Ve a https://github.com/settings/keys
3. Click "New SSH key"
4. Title: NixOS - muere4
5. Pega la clave pública
6. Click "Add SSH key"

3. Agregar clave de facusmzi a GitHub
1. Cierra sesión en GitHub y entra con facusmzi
2. Copia el contenido de ~/.ssh/github_facusmzi.pub
3. Ve a https://github.com/settings/keys
4. Click "New SSH key"
5. Title: NixOS - facusmzi
6. Pega la clave pública
7. Click "Add SSH key"



4. Probar conexión
# Probar muere4
ssh -T git@github.com
# Probar facusmzi
ssh -T git@github.com-facusmzi



Guía Completa: WinApps + Visual Studio en Linux con Podman
1️⃣ Instalar Podman y podman-compose

En NixOS:

nix-env -iA nixpkgs.podman
nix-env -iA nixpkgs.podman-compose


Verifica la instalación:

podman --version
podman info


Para usar VM rootless con KVM, agrega tu usuario al grupo kvm:

sudo usermod -aG kvm $USER
newgrp kvm


Asegúrate de que estás usando crun como runtime, no runc.

2️⃣ Preparar la configuración de WinApps

Crear la carpeta de configuración:

mkdir -p ~/.config/winapps


Crear archivo winapps.conf:

nano ~/.config/winapps/winapps.conf


Contenido mínimo recomendado:

WAFLAVOR="podman"
USERNAME="tu_usuario_windows"
PASSWORD="tu_contraseña_windows"


WAFLAVOR="podman" indica que usarás Podman como backend.

3️⃣ Preparar compose.yaml para Podman

Copia el template de WinApps (puede estar en ~/winapps/compose.yaml o busca con find ~/ -name compose.yaml) a tu configuración:



# For documentation, FAQ, additional configuration options and technical help, visit: https://github.com/dockur/windows

name: "winapps" # Docker Compose Project Name.
volumes:
  # Create Volume 'data'.
  # Located @ '/var/lib/docker/volumes/winapps_data/_data' (Docker).
  # Located @ '/var/lib/containers/storage/volumes/winapps_data/_data' or '~/.local/share/containers/storage/volumes/winapps_data/_data' (Podman).
  data:
services:
  windows:
    image: ghcr.io/dockur/windows:latest
    container_name: WinApps # Created Docker VM Name.
    environment:
      # Version of Windows to configure. For valid options, visit:
      # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-select-the-windows-version
      # https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-install-a-custom-image
      VERSION: "10"
      RAM_SIZE: "2G" # RAM allocated to the Windows VM.
      CPU_CORES: "2" # CPU cores allocated to the Windows VM.
      DISK_SIZE: "30G" # Size of the primary hard disk.
      # DISK2_SIZE: "32G" # Uncomment to add an additional hard disk to the Windows VM. Ensure it is mounted as a volume below.
      USERNAME: "cualquiera" # Edit here to set a custom Windows username. The default is 'MyWindowsUser'.
      PASSWORD: "cualquiera" # Edit here to set a password for the Windows user. The default is 'MyWindowsPassword'.
      HOME: "${HOME}" # Set path to Linux user home folder.
    ports:
      - 8006:8006 # Map '8006' on Linux host to '8006' on Windows VM --> For VNC Web Interface @ http://127.0.0.1:8006.
      - 3389:3389/tcp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
      - 3389:3389/udp # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
    cap_add:
      - NET_ADMIN  # Add network permission
    stop_grace_period: 120s # Wait 120 seconds before sending SIGTERM when attempting to shut down the Windows VM.
    restart: on-failure # Restart the Windows VM if the exit code indicates an error.
    volumes:
      - data:/storage # Mount volume 'data' to use as Windows 'C:' drive.
      - ${HOME}:/shared # Mount Linux user home directory @ '\\host.lan\Data'.
      #- /path/to/second/hard/disk:/storage2 # Uncomment to create a virtual second hard disk and mount it within the Windows VM. Ensure 'DISK2_SIZE' is specified above.
      - ./oem:/oem # Enables automatic post-install execution of 'oem/install.bat', applying Windows registry modifications contained within 'oem/RDPApps.reg'.
      #- /path/to/windows/install/media.iso:/custom.iso # Uncomment to use a custom Windows ISO. If specified, 'VERSION' (e.g. 'tiny11') will be ignored.
    devices:
      - /dev/kvm # Enable KVM.
      - /dev/net/tun # Enable tuntap
      # Uncomment to mount a disk directly within the Windows VM.
      # WARNING: /dev/sdX paths may change after reboot. Use persistent identifiers!
      # NOTE: 'disk1' will be mounted as the main drive. THIS DISK WILL BE FORMATTED BY DOCKER.
      # All following disks (disk2, ...) WILL NOT BE FORMATTED.
      # - /dev/disk/by-id/<id>:/disk1
      # - /dev/disk/by-id/<id>:/disk2
    # group_add:      # uncomment this line and the next one for using rootless podman containers
    #   - keep-groups # to make /dev/kvm work with podman. needs "crun" installed, "runc" will not work! Add your user to the 'kvm' group or another that can access /dev/kvm.

    
    
    

cp ~/winapps/compose.yaml ~/.config/winapps/compose.yaml


Edita ~/.config/winapps/compose.yaml para ajustarlo a tu sistema:

RAM_SIZE: 2GB          # Para sistema con ~4GB RAM
CPU_CORES: 1           # Depende de tu CPU
DISK_SIZE: 30GB        # O 40GB para más margen
VERSION: "10"          # Windows 10


Ajusta según la memoria y disco disponibles.

4️⃣ Verificar módulos de iptables

Para compartir carpetas y que FreeRDP funcione:

lsmod | grep ip_tables
lsmod | grep iptable_nat


Si alguno está vacío:

echo -e "ip_tables\niptable_nat" | sudo tee /etc/modules-load.d/iptables.conf
reboot

5️⃣ Iniciar la VM de Windows
cd ~/.config/winapps
podman-compose --file ./compose.yaml up


La primera vez, WinApps descargará la imagen de Windows (~10–15 GB) y preparará el disco virtual.

Accede a la instalación desde: http://127.0.0.1:8006/ en tu navegador.

6️⃣ Instalar Windows

Completa la instalación normal de Windows vía VNC.

Crea un usuario y contraseña que coincida con USERNAME en winapps.conf.

Formatea el disco virtual de 30 GB (o el que asignaste).

Nota: con 30 GB, Windows funcionará pero tendrás poco espacio libre para programas grandes.

7️⃣ Instalar Visual Studio dentro de Windows

Abre la VM por VNC o RDP.

Descarga Visual Studio Community desde el sitio oficial:
Visual Studio Community

Instálalo normalmente dentro de Windows.

Ten en cuenta el espacio disponible y solo selecciona componentes necesarios.

8️⃣ Ejecutar Visual Studio desde Linux con WinApps
# Ejecuta Visual Studio desde Linux
winapps VisualStudio.exe


Esto abrirá la aplicación como si fuera nativa en Linux usando FreeRDP.

Puedes crear un alias para simplificar:

echo 'alias vs="winapps VisualStudio.exe"' >> ~/.bashrc
source ~/.bashrc
vs

9️⃣ Gestión de la VM
podman-compose --file ./compose.yaml start    # Encender VM
podman-compose --file ./compose.yaml pause    # Pausar VM
podman-compose --file ./compose.yaml unpause  # Reanudar VM
podman-compose --file ./compose.yaml restart  # Reiniciar VM
podman-compose --file ./compose.yaml stop     # Apagar VM
podman-compose --file ./compose.yaml kill     # Forzar apagado


Si editas compose.yaml (RAM, disco, CPU), debes recrear la VM:

podman-compose --file ./compose.yaml down
rm ~/.config/freerdp/server/127.0.0.1_3389.pem
podman-compose --file ./compose.yaml up

🔟 Eliminar todo si quieres empezar de cero
podman-compose --file ./compose.yaml down --rmi all
rm -rf ~/.config/winapps
rm -rf ~/.config/freerdp
podman image prune -a

