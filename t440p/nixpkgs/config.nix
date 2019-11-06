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
        fd
        fzf
        (hiPrio gcc)
        haskellPackages.greenclip
        (import <nixos-unstable> {}).firefox-wayland
        grim
        slurp
        wf-recorder
        wl-clipboard
        git
        htop
        jq
        kitty
      	openjdk
        maven
        nix-index
        nodejs
        python2
        python3
        redshift
        ripgrep
        ruby
        rustup
        stack
        tmux
        tree
        universal-ctags
        unzip
        weston
        wget
        yarn
        leiningen
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}