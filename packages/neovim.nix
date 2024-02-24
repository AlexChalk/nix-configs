{ pkgs ? import <nixpkgs> { } }:

with pkgs; neovim.override {
  configure = {
    customRC = ''
      let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
      execute 'source $HOME/.config/nvim/init.lua'
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ fzf-vim fzfWrapper ];
      opt = [ ];
    };
  };
  extraPython3Packages = ps: with ps; [ pyyaml ];
}
