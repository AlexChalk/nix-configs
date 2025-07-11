{ config, lib, pkgs, ... }:

let
  mkForce = lib.mkForce;

  unstable = pkgs.unstable;
  stable = pkgs.stable;

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  imports =
    [
      ./suspend.nix
      ./calendar-sync.nix
      ./user-update.nix
      ./flakes-update.nix
      ./nix-profile-upgrade.nix
      ./sane-extra-config.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288; # default:  8192

  networking.hostName = "adc-nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enables wireless support via networkmanager.

  programs.nm-applet = {
    # nm-applet (enable to connect to WPA2-Enterprise networks for the first time)
    enable = false;
    indicator = false;
  };

  # Check locally hosted dev server from phone
  # (ssh port is 22 for future setup)
  # 17500 is dropbox
  networking.firewall = {
    allowedTCPPorts = [ 3000 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  # man 5 logind.conf
  # services.logind.extraConfig = ''
  #   HandleLidSwitch=lock
  #   HandleLidSwitchExternalPower=lock
  #   HandleLidSwitchDocked=ignore
  # '';

  fonts.packages = with pkgs; [
    font-awesome
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "ter-122n";
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    colors = [
      "282828"
      "cc241d"
      "98971a"
      "d79921"
      "458588"
      "b16286"
      "689d6a"
      "a89984"
      "928374"
      "fb4934"
      "b8bb26"
      "fabd2f"
      "83a598"
      "d3869b"
      "8ec07c"
      "ebdbb2"
    ];
  };

  services.trezord.enable = true;

  # services.mullvad-vpn = {
  #   enable = true;
  #   package = pkgs.mullvad-vpn;
  # };

  services.gnome = {
    gnome-keyring.enable = true;
    core-os-services.enable = mkForce false;
    core-apps.enable = mkForce false;
    games.enable = mkForce false;
    core-shell.enable = true;
  };

  # "ctrl:swap_lalt_lctl_lwin" Left Alt as Ctrl, Left Ctrl as Win, Left Win as Left
  # Alt, Right Alt as compose key (e.g. for accents)
  services.xserver.xkb.options = "ctrl:nocaps,altwin:swap_lalt_lwin,compose:ralt";
  console.useXkbConfig = true;

  # Set your time zone.
  time.timeZone = "America/Montreal";
  # time.timeZone = "Europe/London";

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    alsa-utils
    coreutils
    dbus
    dmidecode
    dropbox-cli
    git
    killall
    lshw
    libnotify
    lsof
    man
    pavucontrol
    pciutils
    pulseaudio
    qemu_kvm
    dbus-sway-environment
    configure-gtk
    vim
    wget
  ];

  environment.variables = {
    MY_MACHINE = "nixos";
  };

  services.calendarSync.enable = true;

  services.batteryNotifier = {
    enable = true;
    notifyCapacity = 30;
    suspendCapacity = 14;
  };

  services.userUpdate.enable = false;
  services.flakesUpdate.enable = true;
  services.nixProfileUpgrade.enable = true;

  # Power saving
  # https://nixos.wiki/wiki/Laptop
  # https://wiki.archlinux.org/title/TLP
  services.thermald.enable = false;
  services.tlp = {
    enable = false;
    settings = {
      USB_AUTOSUSPEND = 0;
      # TLP_DEFAULT_MODE = "BAT";
      # TLP_PERSISTENT_DEFAULT = 1;
    };
  };

  # powerManagement.powerDownCommands = ''
  #   echo enabled > /sys/bus/usb/devices/usb1/power/wakeup
  #   echo enabled > /sys/bus/usb/devices/usb2/power/wakeup
  #   echo enabled > /sys/bus/usb/devices/usb3/power/wakeup
  #   echo enabled > /sys/bus/usb/devices/usb4/power/wakeup
  # '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #
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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
  ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.nssmdns6 = true;

  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.memcached = {
    enable = true;
    port = 11211;
    listen = "127.0.0.1";
  };

  services.redis.servers.local-test = {
    enable = true;
    port = 6379;
  };

  hardware.keyboard.uhk.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

  # hardware.xpadneo.enable = true;

  # Other hardware
  hardware = {
    enableAllFirmware = true;
    graphics.enable = true;
  };

  hardware.sane.enable = true;
  services.saned.enable = true;
  hardware.sane.extraConfig.pixma = ''
    bjnp-timeout=10000
    bjnp://192.168.0.9
  '';

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 224 ]; events = [ "key" ]; command = "light -A 5"; }
      { keys = [ 225 ]; events = [ "key" ]; command = "light -U 5"; }
    ];
  };

  # https://nixos.wiki/wiki/Dropbox
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "default.target" ];
    environment = {
      DISPLAY = ""; # hack to hide tray icon, https://wiki.archlinux.org/title/Dropbox#Missing_tray_icon_in_wlroots_(sway,_river)
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group";
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  systemd.user.services.zotero = {
    description = "Headless Zotero Instance";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${stable.zotero}/bin/zotero --headless";
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable the sway windowing system.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      glib
      sway-audio-idle-inhibit
      swaybg
      swaylock # lockscreen
      swayidle
      xdg-utils # copy from screen
      libappindicator-gtk3 # tray that just works
      xwayland # for legacy apps
      waybar # status bar
      bemenu
      j4-dmenu-desktop
      mako # notification daemon
      kanshi # autorandr
    ];
  };

  programs.zsh.enable = true;

  services.geoclue2.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/68489#issuecomment-1484030107
  services.geoclue2.enableDemoAgent = lib.mkForce true;
  location.provider = "geoclue2";

  services.redshift = {
    enable = false;
    package = unstable.gammastep;
    executable = "/bin/gammastep";
    temperature.day = 5000;
    temperature.night = 1900;
  };

  systemd.user.targets.sway-session = {
    description = "sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

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

  virtualisation.containers.enable = true;

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = false;
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers.registries.search = [
    "docker.io"
    "quay.io"
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.runAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  virtualisation.spiceUSBRedirection.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.adc = {
    isNormalUser = true;
    home = "/home/adc";
    shell = pkgs.zsh;
    extraGroups = [ "audio" "docker" "libvirtd" "lp" "networkmanager" "scanner" "sway" "video" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.autoUpgrade = {
    enable = true;
    persistent = true;
    flake = "$(${lib.getBin pkgs.coreutils}/bin/dirname $(${lib.getBin pkgs.coreutils}/bin/realpath /etc/nixos/flake.nix))";
    dates = "weekly";
    allowReboot = false;
  };
}
