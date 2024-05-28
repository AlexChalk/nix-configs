{
  description = "nixpkgs configuration";

  inputs = {
    stable-pkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, stable-pkgs, unstable-pkgs, ... }@all:
    let
      system = "x86_64-linux";
      nixpkgs = unstable-pkgs;
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      stable = import stable-pkgs { inherit system; config.allowUnfree = true; };
      unstable = unstable-pkgs.legacyPackages.${system};
      nixops' = unstable.nixops_unstable_full;
      python' = pkgs.python3Full.withPackages (ps: with ps; [ debugpy ]);
      clojure' = pkgs.clojure.override { jdk = pkgs.jdk17; };
    in
    {
      packages.${system}.default =
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
            clojure'
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
            xorg.xkbcomp
            yarn # use yarn instead of npm for global installs
            yq-go
            zathura
            zoom-us
            zotero
            zstd # compression algorithm
            # Neovim
            (callPackage (import ../packages/neovim.nix) { inherit pkgs; })
          ];
          pathsToLink = [ "/share" "/bin" ];
        };
    };
}
