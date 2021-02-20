{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        babashka
        binutils
        # clojure-lsp
        curl
        fd
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
        neofetch
        ngrok
        nodejs-12_x
        pandoc
        python3
        pipenv
        rename
        ripgrep
        rlwrap
        ruby
        tmux
        tree
        universal-ctags
        watchman
        wget
        whois
        yarn
        zathura
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
