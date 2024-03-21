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
          ./t7910/configuration.nix
          ./t7910/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.song = import ./t7910/home.nix;
            home-manager.users.root = import ./t7910/home.nix;
          }
        ];
      };
    };
    darwinConfigurations = {
      Songs-MBP = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.song = import ./darwin/home.nix;
          }
        ];
      };
    };
  };
}
