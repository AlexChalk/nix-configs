let
  unstable = import <nixos-unstable> { };
  stable = import <nixos-stable> { };
in
{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = (import ./default-nixpkgs-linux.nix) { inherit pkgs stable unstable; };
  };
}
