{ pkgs, ... }:

let
  unstable = import <nixos-unstable> { };
  stable = import <nixos-stable> { };
  nixops' = unstable.nixops_unstable_full;
  python' = pkgs.python3Full.withPackages (ps: with ps; [ debugpy ]);
in
pkgs.buildEnv {
  name = "adc-packages";
  paths = with pkgs; [
    calcurse
    libsecret
    acpi
    appimage-run
    anki
    audacity
    babashka
    bashmount
    beets
    binutils
    bitwarden
    bitwarden-cli
    bundix
    castget # rss enclosure downloader
    circleci-cli
    clj-kondo
    unstable.clojure
    curl
    dotnet-sdk
    dotnetPackages.Nuget
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-json
    elmPackages.elm-test
    (callPackage (import ../packages/emoji-launcher.nix) { inherit pkgs; stdenv = pkgs.stdenv; })
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
    imagemagick
    inetutils
    insomnia
    joker
    jq
    keybase-gui
    kitty
    leiningen
    lua5_1
    maven
    unstable.metasploit
    mono
    mpv # media player
    mtools # read ms-dos disks
    neofetch
    nethogs
    netlify-cli
    ngrok
    nix-index
    # nixops'
    nodejs
    nss.tools
    octave
    libsForQt5.okular
    # jdk11 (fix)
    jdk17
    pandoc
    papis
    parted
    poetry
    pomodoro
    poppler_utils
    python'
    python3Packages.pipx
    quickemu
    socat
    rename
    ripgrep
    ruby
    rustup # includes rust-analyzer
    unstable.signal-desktop-beta
    slurp
    unstable.sqlfluff
    unstable.nodePackages.sql-formatter
    stack
    tectonic
    texliveFull
    terraform
    tmux
    tree
    stable.uhk-agent
    universal-ctags
    unzip
    viewnior
    wf-recorder
    wget
    wineWowPackages.waylandFull
    winetricks
    wl-clipboard
    xca
    xorg.xkbcomp
    yarn # use yarn instead of npm for global installs
    yq-go
    zathura
    zoom-us
    zotero
    zstd # compression algorithm
    # Neovim
    (callPackage (import ../packages/neovim.nix) { pkgs = stable; })
    # Language servers/formatters for neovim
    clang-tools
    unstable.clojure-lsp
    elmPackages.elm-language-server
    gopls
    unstable.haskell-language-server
    jdt-language-server
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
    shellcheck
    unstable.stylua
    texlab
    # linters/diagnostics/formatters
    nodePackages.eslint
    python3Packages.flake8
    python3Packages.reorder-python-imports
    black
    isort
    mypy
    pgformatter
    shfmt
  ];
  pathsToLink = [ "/share" "/bin" ];
}
