{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        _1password
        acpi
        brave
        binutils
        clojure
        dropbox-cli
        evince
        fd
        fzf
        gitAndTools.hub
        haskellPackages.greenclip
        gnome3.adwaita-icon-theme
        grim
        slurp
        wf-recorder
        wl-clipboard
        gnome3.gnome-maps
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
        viewnior
        wget
        wine
        xdg_utils
        yarn
        (hiPrio gcc)
        (import <nixos-unstable> {}).firefox-wayland
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
