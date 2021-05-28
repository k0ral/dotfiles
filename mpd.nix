{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  extraConfig = ''
    metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc,comment"
    restore_paused "yes"
    #replaygain "auto"

    audio_output {
      type     "pulse"
      name     "MPD"
      server   "127.0.0.1"
    }
  '';
  musicDirectory = "/home/music";
  network.listenAddress = "any";
  # network.startWhenNeeded = true;
}

