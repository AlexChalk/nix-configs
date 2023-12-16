{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = (import ../../shared/default-nixpkgs-linux.nix) { inherit pkgs; };
  };
}
