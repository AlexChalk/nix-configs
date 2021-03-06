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
        anki
        audacity
        babashka
        bashmount
        beets
        binutils
        bundix
        castget # rss enclosure downloader
        clojure
        clojure-lsp
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
        gitAndTools.gh
        gitAndTools.hub
        gnome3.adwaita-icon-theme
        gnome3.simple-scan
        gnumake
        grim
        gtkpod
        heroku
        hledger
        htop
        joker
        jq
        keybase-gui
        kitty
        leiningen
        lua
        maven
        mono
        mpv # media player
        mtools # read ms-dos disks
        neofetch
        netlify-cli
        nix-index
        nixopsUnstable
        nodejs
        octave
        openjdk
        pandoc
        python3
        rename
        ripgrep
        ruby
        rustup
        signal-desktop
        slurp
        stack
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
        whois
        wine
        winetricks
        wl-clipboard
        xorg.xkbcomp
        yarn # use yarn instead of npm for global installs
        zathura
        zoom-us
        teams
        zstd # compression algorithm
        (callPackage (import ../../packages/neovim.nix) {})
        (callPackage (import ../../packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
