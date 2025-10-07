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

