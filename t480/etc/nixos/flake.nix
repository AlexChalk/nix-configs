{
  description = "My system config";
  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, stable, unstable, nixos-hardware }@all:
    let
      system = "x86_64-linux";
      nixpkgs = unstable;
      overlays = [
        (final: prev: {
          unstable = import unstable {
            inherit system;
            config = prev.config;
          };
          stable = import stable {
            inherit system;
            config = prev.config;
          };
        })
      ];
    in
    {
      nixosConfigurations."adc-nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit nixos-hardware;
        };
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = overlays;
          })
          ./configuration.nix
        ];
      };
    };
}
