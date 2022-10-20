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
        (import <nixos-unstable> {}).dropbox-cli
        elmPackages.elm
        elmPackages.elm-format
        elmPackages.elm-json
        elmPackages.elm-test
        (callPackage (import ../../packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
        fd
        ffmpeg
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
        (import <nixos-unstable> {}).sqlfluff
        (import <nixos-unstable> {}).nodePackages.sql-formatter
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
        # Neovim
        (callPackage (import ../../packages/neovim.nix) { pkgs = import <nixos-unstable> {}; })
        # Language servers/formatters for neovim
        clang-tools
        (import <nixos-unstable> {}).clojure-lsp
        elmPackages.elm-language-server
        gopls
        (import <nixos-unstable> {}).haskell-language-server
        nodePackages.bash-language-server
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.vscode-json-languageserver
        nodePackages.yaml-language-server
        rnix-lsp
        sumneko-lua-language-server
        terraform-ls
        rubyPackages.solargraph
        rust-analyzer
        shellcheck
        (import <nixos-unstable> {}).stylua
        texlab
        # linters/diagnostics/formatters
        nodePackages.eslint
        python39Packages.flake8
        pgformatter
        shfmt
        black
        mypy
        shfmt
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
