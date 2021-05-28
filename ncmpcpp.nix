{ pkgs ? import <nixpkgs> {} }:

{
  enable = true;
  mpdMusicDir = "/home/music";
  settings = {
    mpd_host = "127.0.0.1";
    mpd_crossfade_time = "5";
    now_playing_prefix = "$b";
    now_playing_suffix = "$/b";
    selected_item_prefix = "$2";
    selected_item_suffix = "$9";
    song_columns_list_format = "(7f)[magenta]{l} (20)[red]{aE} (30)[yellow]{tE} (4f)[magenta]{nE:N°} (15)[blue]{bE} (5f)[magenta]{yE} (15f)[cyan]{gEr} (15f)[magenta]{CEr}";
    browser_display_mode = "columns";
    search_engine_display_mode = "columns";
    playlist_editor_display_mode = "columns";
    autocenter_mode = true;
    user_interface = "alternative";
    allow_for_physical_item_deletion = true;
    display_remaining_time = true;
    tag_editor_extended_numeration = true;
    volume_color = "red";
    state_flags_color = "cyan";
    progressbar_color = "red";
  };
  bindings = [
    { key = "space"; command = "pause"; }
    { key = "delete"; command = "delete_playlist_items"; }
    { key = "d"; command = "delete_browser_items"; }
    { key = "left"; command = "seek_backward"; }
    { key = "right"; command = "seek_forward"; }
    { key = "A"; command = "add_selected_items"; }
    { key = "a"; command = "add_item_to_playlist"; }
    { key = "n"; command = "next_found_item"; }
    { key = "p"; command = "previous_found_item"; }
  ];
}

