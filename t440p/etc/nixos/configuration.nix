# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/lenovo/thinkpad/t440p>
      ../../../shared/default-nixos-linux.nix
    ];

  # Only update this if you do a completely fresh install.
  # https://nixos.org/nixos/options.html#system.stateversion
  system.stateVersion = "21.05";
}
