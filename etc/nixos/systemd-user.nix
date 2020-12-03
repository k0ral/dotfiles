{ config, pkgs, ... }: {

  systemd.user.services.backup = {
    description = "Backup";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = [
        "-${pkgs.git}/bin/git -C %h/.config push"
        "-/bin/sh -c '${pkgs.notmuch}/bin/notmuch config list >| %h/.config/notmuch/config_all'"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper create --remote-path=borg1 -x -C lzma \"17994@ch-s011.rsync.net:backup::{utcnow}-{hostname}\" %h/doc %h/feeds %h/images %h/papers %h/prog/archive %h/studies %h/.config %h/.mozilla %h/.thunderbird %h/.task'"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper prune --remote-path=borg1 -d 30 \"17994@ch-s011.rsync.net:backup\"'"
      ];

      Type = "oneshot";
    };
  };

  systemd.user.services.cleanup = {
    description = "$HOME clean-up";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        #"${pkgs.coreutils}/bin/chmod -R go-rwx %h/mail %h/papers %h/.gnupg"
        "-${pkgs.coreutils}/bin/mv -u %h/Downloads/* %h/Desktop/* %h"
        "-${pkgs.coreutils}/bin/rm -d %h/Downloads %h/Desktop"
        #/run/current-system/sw/bin/detox -r /home/music
      ];
    };
  };

  systemd.user.services.pueue = {
    description = "CLI process scheduler and manager";
    wantedBy = [ "default.target" ];

    serviceConfig = { ExecStart = "${pkgs.pueue}/bin/pueued"; };
  };

  systemd.user.timers.backup = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "backup.service";
      OnCalendar = "daily";
    };
  };

  systemd.user.timers.cleanup = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "cleanup.service";
      OnBootSec = "3h";
      OnUnitActiveSec = "5h";
    };
  };

}
