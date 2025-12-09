final: prev: {
  # Importar paquetes personalizados
  yaak = prev.callPackage ./yaak/default.nix {};

  # Aquí podés agregar más paquetes en el futuro:
  # mi-otro-paquete = prev.callPackage ./mi-otro-paquete/default.nix {};
}
