{
  description = "ghostylee's NixOS and Darwin Configuration in flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: {
    nixosConfigurations = {
      nuc-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.song = import ./home.nix;
            home-manager.users.root = import ./home.nix;
          }
        ];
      };
      T7910-Song = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/T7910-Song/configuration.nix
          ./hosts/T7910-Song/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.song = import ./hosts/T7910-Song/home.nix;
            home-manager.users.root = import ./hosts/T7910-Song/home.nix;
          }
        ];
      };
    };
    darwinConfigurations = {
      Songs-MBP = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/Songs-MBP/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.song = import ./hosts/Songs-MBP/home.nix;
          }
        ];
      };
    };
  };
}
