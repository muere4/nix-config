{
  description = "Mi configuración NixOS";

  inputs = {
    # Stable 25.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, dms, ... }@inputs:
    let
      system = "x86_64-linux";

      # Overlay para tener unstable disponible como pkgs.unstable
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      overlay-packages = import ./overlays/default.nix;

    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };  # Pasar inputs
          modules = [
            # Agregar el overlay
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
              nixpkgs.config.allowUnfree = true;
            })

            ./hosts/nixos/configuration.nix
            ./hosts/nixos/hardware-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.muere = import ./home/default.nix;
              home-manager.backupFileExtension = "backup";

              home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            }
          ];
        };

        nixi = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };  # Pasar inputs
          modules = [
            # Agregar el overlay
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [
                overlay-unstable
                overlay-packages
              ];
              nixpkgs.config.allowUnfree = true;
            })

            ./hosts/nixi/configuration.nix
            ./hosts/nixi/hardware-configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.muere = import ./home/default.nix;
              home-manager.backupFileExtension = "backup";

              home-manager.sharedModules = [
                plasma-manager.homeModules.plasma-manager
                inputs.dms.homeModules.dankMaterialShell.default
              ];
            }
          ];
        };
      };

      # Templates al mismo nivel que nixosConfigurations
      templates = import ./templates/default.nix;
    };
}
