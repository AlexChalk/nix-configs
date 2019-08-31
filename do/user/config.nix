{
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        # binutils # maybe just in build env
        clojure
        fd
        fzf
        (hiPrio gcc) # prio needed due to binutils conflict
        git
        htop
      	openjdk
        maven
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
        leiningen
        (callPackage (import ./packages/neovim.nix) {})
      ];
    };
  };
}
