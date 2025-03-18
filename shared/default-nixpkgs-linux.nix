{ pkgs, stable, unstable, ... }:

# See https://nixos.org/manual/nixpkgs/stable/#sec-building-environment
let
  nixops' = unstable.nixops_unstable_full;
  python' = pkgs.python3Full.withPackages (ps: with ps; [ debugpy ]);
  clojure' = pkgs.clojure.override { jdk = pkgs.jdk17; };
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
    binutils
    bitwarden
    bitwarden-cli
    bundix
    # castget # rss enclosure downloader
    circleci-cli
    clj-kondo
    clojure'
    cmus
    rclone
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
    flac
    fsharp
    fzf
    (hiPrio gcc)
    git
    git-lfs
    gitAndTools.gh
    gitAndTools.hub
    adwaita-icon-theme
    simple-scan
    gnumake
    grim
    unstable.heroku
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
    mp3val
    mpv # media player
    mtools # read ms-dos disks
    neofetch
    nethogs
    ngrok
    nix-index
    # nixops'
    nodejs
    nss.tools
    octave
    libsForQt5.okular
    jdk17
    pandoc
    papis
    parted
    pdfarranger
    poetry
    pomodoro
    poppler_utils
    python'
    python3Packages.pipx
    stable.quickemu
    socat
    rename
    ripgrep
    ruby
    rustup # includes rust-analyzer
    unstable.signal-desktop
    slurp
    stack
    stylua
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
    xorg.xauth
    xorg.xkbcomp
    yarn # use yarn instead of npm for global installs
    yq-go
    zathura
    zoom-us
    stable.zotero
    zstd # compression algorithm
    # Neovim
    (callPackage (import ../packages/neovim.nix) { })
  ];
  pathsToLink = [ "/share" "/bin" ];
}
