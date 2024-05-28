# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };

      stable = import <nixos-stable> {
        config = config.nixpkgs.config;
      };
    })
  ];

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/lenovo/thinkpad/t480>
      ../../../shared/default-nixos-linux.nix
    ];

  # Only update this if you do a completely fresh install.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
