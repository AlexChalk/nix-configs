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
        circleci-cli
        clj-kondo
        (import <nixos-unstable> {}).clojure
        curl
        dotnet-sdk
        dotnetPackages.Nuget
        dropbox-cli
        elmPackages.elm
        elmPackages.elm-format
        elmPackages.elm-json
        elmPackages.elm-test
        fd
        ffmpeg
        (import <nixos-20-09> {}).firefox-wayland
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
        insomnia
        joker
        jq
        keybase-gui
        kitty
        leiningen
        lua5_1
        maven
        mono
        mpv # media player
        mtools # read ms-dos disks
        neofetch
        netlify-cli
        ngrok
        nix-index
        nixopsUnstable
        nodejs
        octave
        jdk11
        pandoc
        parted
        python3
        rename
        ripgrep
        ruby
        rustup
        signal-desktop
        slurp
        stack
        terraform
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
        (callPackage (import ../../packages/neovim.nix) { pkgs = import <nixos-unstable> {}; })
        (callPackage (import ../../packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
        (import <nixos-unstable> {}).stylua
        # Language servers
        (import <nixos-unstable> {}).clojure-lsp
        elmPackages.elm-language-server
        haskell-language-server
        nodePackages.bash-language-server
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vim-language-server
        nodePackages.vscode-json-languageserver
        rnix-lsp
        rust-analyzer
        shellcheck
        (import <nixos-unstable> {}).stylua
        terraform-ls
        texlab
        sumneko-lua-language-server
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
