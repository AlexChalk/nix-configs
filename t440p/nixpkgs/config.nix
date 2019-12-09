{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        _1password
        acpi
        binutils
        clojure
        dropbox-cli
        evince
        fd
        fzf
        (hiPrio gcc)
        gitAndTools.hub
        haskellPackages.greenclip
        (import <nixos-unstable> {}).firefox-wayland
        grim
        slurp
        wf-recorder
        wl-clipboard
        gnome3.gnome-maps
        git
        htop
        jq
        kitty
      	openjdk
        maven
        neofetch
        nix-index
        nodejs
        python2
        python3
        python2Packages.pynvim
        python3Packages.pynvim
        redshift
        ripgrep
        ruby
        rustup
        skypeforlinux
        stack
        terraform
        tmux
        tree
        universal-ctags
        unzip
        wget
        wire-desktop
        yarn
        leiningen
        gnome3.adwaita-icon-theme
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
