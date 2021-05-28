{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  settings = {
    hide_userland_threads = true;
    highlight_base_name = true;
    highlight_megabytes = true;
    show_program_path = false;
    tree_view = true;
  };
}

