{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        _1password
        acpi
        asciidoctor
        brave
        binutils
        clojure
        dropbox-cli
        evince
        fd
        firefox-wayland
        fzf
        gitAndTools.hub
        haskellPackages.greenclip
        gnome3.adwaita-icon-theme
        gnome3.gnome-keyring
        grim
        slurp
        wf-recorder
        wl-clipboard
        gnome3.gnome-maps
        gnome3.gnome-control-center
        gnome3.simple-scan
        git
        htop
        jq
        kitty
        leiningen
      	openjdk
        maven
        neofetch
        nixops
        nix-index
        nodejs
        pandoc
        python2
        python3
        python2Packages.pynvim
        python3Packages.pynvim
        ripgrep
        ruby
        rustup
        stack
        subversion
        terraform
        texlive.combined.scheme-medium
        tmux
        tree
        universal-ctags
        unzip
        viewnior
        wget
        wine
        winetricks
        xdg_utils
        yarn
        zathura
        (hiPrio gcc)
        (import <nixos-unstable> {}).skypeforlinux
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
