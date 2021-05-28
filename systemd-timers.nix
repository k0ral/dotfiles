{ pkgs ? import <nixpkgs> {} }:

{
  backup = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "backup.service";
      OnCalendar = "daily";
    };
  };

  cleanup = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "cleanup.service";
      OnBootSec = "3h";
      OnUnitActiveSec = "5h";
    };
  };

  wallpaper = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "wallpaper.service";
      OnBootSec = "1m";
      OnUnitActiveSec = "11m";
    };
  };
}

