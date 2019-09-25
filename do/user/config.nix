{
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        clojure
        fd
        fzf
        gcc
        git
        htop
      	openjdk
        maven
        nodejs
        python2
        python3
        ripgrep
        ruby
        rustup
        stack
        tmux
        tree
        universal-ctags
        unzip
        wget
        yarn
        leiningen
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
