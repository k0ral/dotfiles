{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  font = {
    name = "Ubuntu";
    package = pkgs.ubuntu_font_family;
  };

  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
}

