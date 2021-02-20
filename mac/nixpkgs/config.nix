{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        babashka
        binutils
        clojure-lsp
        curl
        fd
        firefox
        fzf
        gawk
        git
        gitAndTools.gh
        gitAndTools.hub
        gnumake
        gnused
        heroku
        htop
        jq
        kitty
        neofetch
        ngrok
        nodejs-12_x
        pandoc
        python3
        python3Packages.pynvim
        pipenv
        rename
        ripgrep
        rlwrap
        ruby
        skhd
        tmux
        tree
        universal-ctags
        watchman
        wget
        whois
        yabai
        yarn
        zathura
        (callPackage (import ./packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
