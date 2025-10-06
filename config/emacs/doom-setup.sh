#!/usr/bin/env bash

EMACS_DIR="$HOME/.config/emacs"
DOOM_CONFIG_DIR="$HOME/.config/doom"
SOURCE_CONFIG="$HOME/nix-config/doom"

echo "Configurando Doom Emacs..."

# Verificar si ya existe
if [ -d "$EMACS_DIR" ]; then
    echo "Doom Emacs ya está instalado en $EMACS_DIR"
    read -p "¿Reinstalar? Esto eliminará la instalación actual. (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$EMACS_DIR"
        rm -rf "$DOOM_CONFIG_DIR"
    else
        echo "Cancelado."
        exit 0
    fi
fi

# Clonar Doom
echo "Clonando Doom Emacs..."
git clone --depth 1 https://github.com/doomemacs/doomemacs "$EMACS_DIR"

# Copiar configuración personal
echo "Copiando configuración personal..."
mkdir -p "$DOOM_CONFIG_DIR"
cp -r "$SOURCE_CONFIG"/* "$DOOM_CONFIG_DIR/"

# Instalar
echo "Instalando Doom..."
"$EMACS_DIR/bin/doom" install

# Sincronizar
echo "Sincronizando configuración..."
"$EMACS_DIR/bin/doom" sync

echo "Doom Emacs instalado correctamente"
echo "Ejecuta 'doom doctor' para verificar dependencias"
