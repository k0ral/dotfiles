{ pkgs ? import <nixpkgs> {} }:

{
  backup = {
    Unit.Description = "Backup";
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = [
        "-${pkgs.git}/bin/git -C %h/.config push"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper create --remote-path=borg1 -x -C lzma \"17994@ch-s011.rsync.net:backup::{utcnow}-{hostname}\" %h/doc %h/feeds %h/images %h/papers %h/prog/archive %h/studies %h/.config %h/.cache/evolution %h/.local/share/evolution %h/tiddlywiki'"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper prune --remote-path=borg1 -d 30 \"17994@ch-s011.rsync.net:backup\"'"
      ];

      Type = "oneshot";
    };
  };

  cleanup = {
    Unit.Description = "$HOME clean-up";
    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "oneshot";
      ExecStart = [
        "-${pkgs.coreutils}/bin/mv -u %h/Downloads/* %h/Desktop/* %h"
        "-${pkgs.coreutils}/bin/rm -d %h/Downloads %h/Desktop"
        #/run/current-system/sw/bin/detox -r /home/music
      ];
    };
  };

  pueue = {
    Unit.Description = "CLI process scheduler and manager";
    Install.WantedBy = [ "default.target" ];

    Service = { ExecStart = "${pkgs.pueue}/bin/pueued"; };
  };

  tiddlywiki2 = let
    exe = "${pkgs.nodePackages.tiddlywiki}/bin/tiddlywiki";
    dataDir = "/home/koral/tiddlywiki";
  in {
    Unit = {
      Description = "TiddlyWiki nodejs server";
      After = [ "network.target" ];
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "simple";
      Restart = "on-failure";
      # DynamicUser = true;
      # StateDirectory = name;
      ExecStartPre = "-${exe} ${dataDir} --init server";
      ExecStart = "${exe} ${dataDir} --listen";
    };
  };

  wallpaper =
    let setrandom = pkgs.writeShellScriptBin "setrandom" ''
          export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(${pkgs.procps}/bin/pgrep -f 'sway$').sock
          #export SWAYSOCK="$(${pkgs.sway}/bin/sway --get-socketpath)"
          ${pkgs.nix}/bin/nix-shell -p wallutils -p sway --run "setrandom -v /home/koral/images/wallpapers"
        '';
    in {
      Unit.Description = "Random wallpaper";
      Install.WantedBy = [ "default.target" ];

      Service = {
        Type = "oneshot";
        ExecStart = "-${setrandom}/bin/setrandom";
      };
    };

  # xdg-desktop-portal-wlr = {
  #   Unit.Description = "Portal service (wlroots implementation)";
  #   Install.WantedBy = [ "default.target" ];
  #   # requires= [ "pipewire.service" ];

  #   Service = {
  #     Type = "dbus";
  #     BusName = "org.freedesktop.impl.portal.desktop.wlr";
  #     ExecStart = [
  #       "" # Override for trace
  #       "${pkgs.xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr -l TRACE"
  #     ];
  #     Restart = "on-failure";
  #   };
  # };
}

