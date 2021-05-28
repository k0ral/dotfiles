{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  settings = {
    directory = "/home/music";
    library = "~/.config/beets/library.blb";
    plugins = "acousticbrainz chroma fromfilename lastgenre duplicates replaygain";

    import = {
      asciify_paths = true;
      copy = false;
      none_rec_action = "skip";
      duplicate_action = "keep";
      group_albums = true;
    };

    paths = {
      default = "$album%aunique{}/$artist/$title";
      singleton = "$album%aunique{}/$artist/$title";
      comp = "compilations/$album%aunique{}/$title";
    };

    match = {
      strong_rec_thresh = 0.10;
    };

    duplicates = {
      keys = [ "acoustid_fingerprint" ];
      path = true;
      strict = true;
    };

    replaygain = {
      backend = "gstreamer";
    };
  };
}
