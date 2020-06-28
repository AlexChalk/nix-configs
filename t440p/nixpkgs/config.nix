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
        (import <nixos-unstable> {}).clojure-lsp
        dmidecode
        dropbox-cli
        fd
        firefox-wayland
        fzf
        gitAndTools.hub
        gnumake
        handbrake
        haskellPackages.greenclip
        hledger
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
        (lowPrio graalvm8)
        htop
        joker
        jq
        kitty
        leiningen
        libappindicator
        lua
      	openjdk
        maven
        mono
        dotnet-sdk
        dotnetPackages.Nuget
        fsharp
        mpv
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
        yarn # use yarn instead of npm for global installs
        zathura
        (hiPrio gcc)
        (import <nixos-unstable> {}).skypeforlinux
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
