{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        _1password
        _1password-gui
        acpi
        appimage-run
        binutils
        bundix
        clojure
        (import <nixos-unstable> {}).clojure-lsp
        dropbox-cli
        elmPackages.elm
        elmPackages.elm-format
        elmPackages.elm-test
        elmPackages.elm-language-server
        elmPackages.elm-json
        fd
        firefox-wayland
        fzf
        gitAndTools.hub
        gnumake
        hledger
        gnome3.adwaita-icon-theme
        grim
        slurp
        wf-recorder
        wl-clipboard
        gnome3.simple-scan
        git
        htop
        joker
        jq
        octave
        kitty
        leiningen
        lua
      	openjdk
        maven
        mono
        dotnet-sdk
        dotnetPackages.Nuget
        fsharp
        mpv
        neofetch
        netlify-cli
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
        (import <nixos-unstable> {}).signal-desktop
        stack
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
        yarn # use yarn instead of npm for global installs
        zathura
        (hiPrio gcc)
        (callPackage (import ./packages/neovim.nix) {})
        (callPackage (import ./packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
