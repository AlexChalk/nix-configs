{
  allowUnfree = true;
  packageOverrides = pkgs: {
    adcPackages = with pkgs;
      let
        python-libs = python-libs: with python-libs; [
          debugpy
        ];
        python3WithLibs = python3.withPackages python-libs;
        mariadb = pkgs.mariadb.overrideAttrs (oldAttrs: rec {
          cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
            "-DPLUGIN_AUTH_PAM=NO"
          ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            "-DPLUGIN_AUTH_PAM=NO"
            "-DPLUGIN_AUTH_PAM_V1=NO"
          ];
        });
      in
      pkgs.buildEnv {
        name = "adc-packages";
        paths = [
          awscli2
          (import <nixpkgs-stable> { }).aws-mfa
          bash
          binutils
          bundix
          curl
          # ddrescue
          eksctl
          envconsul
          envsubst
          fd
          ffmpeg
          flac
          fzf
          gawk
          git
          gitAndTools.gh
          gitAndTools.hub
          gnumake
          gnused
          go
          google-cloud-sdk
          graphviz
          heroku
          htop
          imagemagick
          jq
          kustomize
          mariadb
          minikube
          # mp3info
          mp3val
          neofetch
          nodePackages.redoc-cli
          nodejs-14_x
          pandoc
          poetry
          pre-commit
          python3Packages.pipx
          python3Packages.tox
          python3WithLibs
          rclone
          rename
          ripgrep
          rlwrap
          ruby
          shellcheck
          # sonar-scanner-cli
          (import <nixpkgs-stable> { }).terraform_0_12
          tmux
          tmux-xpanes
          tree
          vault
          watch
          watchman
          wget
          whois
          (import <nixpkgs-stable> { }).yarn
          yq
          zathura
          zsh
          (callPackage (import ../../packages/neovim.nix) { })
          # language servers
          nodePackages.bash-language-server
          nodePackages.dockerfile-language-server-nodejs
          nodePackages.pyright
          (import <nixpkgs-stable> { }).nodePackages.typescript-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.vscode-json-languageserver
          nodePackages.yaml-language-server
          rnix-lsp
          sumneko-lua-language-server
          terraform-ls
          # linters/diagnostics/formatters
          nodePackages.eslint
          python39Packages.flake8
          pgformatter
          shfmt
          stylua
          black
          mypy
        ];
        pathsToLink = [ "/share" "/bin" ];
      };
  };
}
