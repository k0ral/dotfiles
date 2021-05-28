{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  extraConfig = builtins.readFile ./tmux/tmux.conf;
  terminal = "xterm-kitty";
  tmuxp.enable = true;
}
