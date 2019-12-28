# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  mkForce = lib.mkForce;
  unstable = import <nixos-unstable> {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t440p>
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  boot.kernelModules = [ "kvm-intel" "iwlwifi" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.extraModprobeConfig = ''
  #   thinkpad_acpi
  # '';

  networking.hostName = "adc-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via networkmanager.
  # networking.wireless.enable = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  fonts.fonts = with pkgs; [
    font-awesome
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consolePackages = [ pkgs.terminus_font ];
    consoleFont = "ter-122n";
    consoleColors = [ 
      "282828" "fb4934" "b8bb26" "fabd2f" "83a598" "d3869b" "8ec07c" "d5c4a1"
      "665c54" "fb4934" "b8bb26" "fabd2f" "83a598" "d3869b" "8ec07c" "fbf1c7"
    ];
    defaultLocale = "en_US.UTF-8";
  };


  services.gnome3 = {
    gnome-keyring.enable = mkForce false;
    core-os-services.enable = mkForce false;
    core-utilities.enable = mkForce false;
    games.enable = mkForce false;
    core-shell.enable = true;
  };
  # services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.gnome3.extraGSettingsOverrides = ''
    [org.gnome.desktop.interface]
    cursor-theme='Adwaita'
    cursor-size=24
  '';

  # "ctrl:swap_lalt_lctl_lwin" Left Alt as Ctrl, Left Ctrl as Win, Left Win as Left Alt
  services.xserver.xkbOptions = "ctrl:nocaps,altwin:swap_lalt_lwin";
  i18n.consoleUseXkbConfig = true;

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    git killall lshw lsof man pavucontrol pciutils qemu_kvm vim virtmanager wget zsh
    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/bash

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
          '';
      }
    )
  ];

  environment.variables = {
    MY_MACHINE = "nixos";
    XDG_CURRENT_DESKTOP = "Unity";
    XCURSOR_SIZE = "32";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    cnijfilter2 cups-bjnp gutenprint
  ];
  # services.avahi.enable = true;
  # services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  # Other hardware
  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    opengl.enable = true;
    pulseaudio.enable = true;
  };
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "light -A 5"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "light -U 5"; }
    ];
  };

  # Enable the sway windowing system.
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaybg
      swaylock # lockscreen
      swayidle
      xwayland # for legacy apps
      waybar # status bar
      bemenu
      j4-dmenu-desktop
      mako # notification daemon
      kanshi # autorandr
    ];
  };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.geoclue2.enable= true;
  location.provider = "geoclue2";

  services.redshift = {
    enable = true;
    package = unstable.redshift-wlr;
    temperature.day = 5000;
    temperature.night = 1900;
  };

  # programs.waybar.enable = true;

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adc = {
    isNormalUser = true;
    home = "/home/adc";
    shell = pkgs.zsh;
    extraGroups = [ "docker" "libvirtd" "networkmanager" "sway" "video" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
