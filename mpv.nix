{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  config = {
    audio-display = false;
    keep-open = "always";
  };
  bindings = {
    F2 = "af toggle \"lavfi=[dynaudnorm=f=75:g=25:n=0:p=0.58]\"";
  };
}

