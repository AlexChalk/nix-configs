{
  description = "nixpkgs configuration";

  inputs = {
    stable-pkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, stable-pkgs, unstable-pkgs, ... }@all:
    let
      system = "x86_64-linux";
      nixpkgs = unstable-pkgs;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = import ../shared/default-overlays-linux.nix;
      };
      stable = import stable-pkgs { inherit system; config.allowUnfree = true; };
      unstable = unstable-pkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = (import ../shared/default-nixpkgs-linux.nix) { inherit pkgs stable unstable; };
      adc-packages = self.packages.${system}.default;
    };
}
