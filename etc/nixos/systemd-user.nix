{ config, pkgs, ... }: {
  systemd.user.services = {
    backup = {
      description = "Backup";
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = [
          "-${pkgs.git}/bin/git -C %h/.config push"
          "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper create --remote-path=borg1 -x -C lzma \"17994@ch-s011.rsync.net:backup::{utcnow}-{hostname}\" %h/doc %h/feeds %h/images %h/papers %h/prog/archive %h/studies %h/.config %h/.mozilla %h/.thunderbird %h/.task %h/tiddlywiki'"
          "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper prune --remote-path=borg1 -d 30 \"17994@ch-s011.rsync.net:backup\"'"
        ];

        Type = "oneshot";
      };
    };

    cleanup = {
      description = "$HOME clean-up";
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = [
          "-${pkgs.coreutils}/bin/mv -u %h/Downloads/* %h/Desktop/* %h"
          "-${pkgs.coreutils}/bin/rm -d %h/Downloads %h/Desktop"
          #/run/current-system/sw/bin/detox -r /home/music
        ];
      };
    };

    pueue = {
      description = "CLI process scheduler and manager";
      wantedBy = [ "default.target" ];

      serviceConfig = { ExecStart = "${pkgs.pueue}/bin/pueued"; };
    };

    tiddlywiki = let
      exe = "${pkgs.nodePackages.tiddlywiki}/lib/node_modules/.bin/tiddlywiki";
      dataDir = "/home/koral/tiddlywiki";
    in {
      description = "TiddlyWiki nodejs server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        # DynamicUser = true;
        # StateDirectory = name;
        ExecStartPre = "-${exe} ${dataDir} --init server";
        ExecStart = "${exe} ${dataDir} --listen";
      };
    };
  };

  systemd.user.timers = {

    backup = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        Unit = "backup.service";
        OnCalendar = "daily";
      };
    };

    cleanup = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        Unit = "cleanup.service";
        OnBootSec = "3h";
        OnUnitActiveSec = "5h";
      };
    };
  };
}
