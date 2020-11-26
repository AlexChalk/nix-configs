{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        _1password
        (import <nixos-unstable> {})._1password-gui
        acpi
        appimage-run
        audacity
        bashmount
        beets
        binutils
        bundix
        castget
        clojure
        (import <nixos-unstable> {}).clojure-lsp
        dotnet-sdk
        dotnetPackages.Nuget
        dropbox-cli
        elmPackages.elm
        elmPackages.elm-format
        elmPackages.elm-json
        elmPackages.elm-language-server
        elmPackages.elm-test
        fd
        firefox-wayland
        fsharp
        fzf
        (hiPrio gcc)
        git
        gitAndTools.hub
        gnome3.adwaita-icon-theme
        gnome3.simple-scan
        gnumake
        grim
        gtkpod
        hledger
        htop
        joker
        jq
        kitty
        leiningen
        lua
        maven
        mono
        mpv
        mtools
        neofetch
        netlify-cli
        nix-index
        nixops
        nodejs
        octave
        openjdk
        pandoc
        python2
        python2Packages.pynvim
        python3
        python3Packages.pynvim
        ripgrep
        ruby
        rustup
        (import <nixos-unstable> {}).signal-desktop
        slurp
        stack
        superTuxKart
        terraform
        texlab
        texlive.combined.scheme-full
        tmux
        tree
        universal-ctags
        unzip
        viewnior
        wf-recorder
        wget
        wine
        winetricks
        wl-clipboard
        yarn # use yarn instead of npm for global installs
        zathura
        (callPackage (import ./packages/neovim.nix) {})
        (callPackage (import ./packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
