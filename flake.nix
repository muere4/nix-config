{
  description = "Configuración básica de NixOS con stable 25.05, unstable y Home Manager";

  inputs = {
    # Canal stable 25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Canal unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager 25.05
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Cambia "hostname" por el nombre de tu sistema
      pichi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          # Hacer disponible el canal unstable como "unstable"
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./nixos-configurations/pichi/configuration.nix

          # Habilitar Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.muere = import ./pichi.nix; # Tu usuario actual

              # Pasar argumentos adicionales a Home Manager
              extraSpecialArgs = {
                inherit inputs;
                unstable = import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
              };
            };
          }
        ];
      };
    };
  };
}
