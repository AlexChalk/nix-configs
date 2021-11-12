{ pkgs ? import <nixpkgs> {} }:

with pkgs; neovim.override {
  configure = {
    customRC = "execute 'source $HOME/.config/nvim/init.lua'";
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [ fzf-vim fzfWrapper ];
      opt = [ ];
    }; 
  };
}
