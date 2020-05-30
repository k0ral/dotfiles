{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.supportedFilesystems = [ "zfs" ];


  environment.systemPackages =
    let audioPack = with pkgs; [ beets flac mpc_cli ncmpcpp ncpamixer opusTools pamixer paprefs vorbis-tools ];
        cliPack = with pkgs; [ exa fd fish fzf gcalcli grc gron loop ncurses.dev ripgrep tldr urlscan yank zsh ];
        devPack = with pkgs; [ binutils cabal-install cacert chromaprint git gitAndTools.diff-so-fancy gitAndTools.hub gnumake graphviz icu jq libxml2 mercurial neovim nodejs openssl pandoc patchelf pkgconfig poppler_utils python3 tig wkhtmltopdf z3 ];
        fsPack = with pkgs; [ atool borgbackup detox dfc encfs file libarchive libmtp libnotify ncdu ntfs3g p7zip rmlint rsync sshfsFuse tree unrar unzip zip ];
        graphicalPack = with pkgs; [ dmenu dzen2 keynav kitty qt5.qtwayland wallutils xorg.xev ]; # i3lock-fancy 
        haskellPack = with pkgs.haskellPackages; [ apply-refact brittany dhall doctest ghc happy haskell-ci hdevtools hlint stylish-haskell ]; # hakyll hasktags open-haddock haddocset hledger hindent ghc-mod summoner
        mediaPack = with pkgs; [ evince exiftool ffmpeg imagemagick jpegoptim lsdvd mediainfo mkvtoolnix-cli mpv pdf2svg rtv ];
        netPack = with pkgs; [ aria2 arp-scan bluez bluez-tools elinks firefox-wayland googler iftop isync mcabber msmtp neomutt nload notmuch obexfs tcpdump tcpflow telnet w3m weechat wget ];
        nixPack = with pkgs; [ cabal2nix cachix nix-du nix-top nox ];
        pythonPack = with pkgs.python3Packages; [ glances grip mps-youtube mutagen virtualenv youtube-dl ];
        systemPack = with pkgs; [ abduco acpi alsaUtils atop cpulimit htop light lsof man moreutils pciutils powertop progress ps_mem psmisc rfkill smartmontools udiskie usbutils ];
        utilsPack = with pkgs; [ dict taskwarrior ];
        hie = [ (import /home/hie-nix/default.nix {}).hie86 ];
    in builtins.concatLists [ audioPack cliPack devPack fsPack graphicalPack mediaPack netPack nixPack pythonPack systemPack utilsPack haskellPack ];


  environment.variables = {
    BROWSER="firefox";
    EDITOR="nvim";
    MOZ_ENABLE_WAYLAND="1";
    QT_QPA_PLATFORM="wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
  };


  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts  # Micrsoft free fonts
    fira-code
    font-awesome
    hack-font
    hasklig
    # inconsolata
    iosevka
    source-code-pro
    unifont # some international languages
    ];
  fonts.fontconfig.defaultFonts.monospace = [ "Hack" ];


  hardware.bluetooth.enable = true;
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    tcp.enable = true;
    tcp.anonymousClients.allowAll = true;
    zeroconf.discovery.enable = true;
    zeroconf.publish.enable = true;
  };

  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking.firewall.allowedTCPPorts = [ 873 6600 ];
  networking.enableIPv6 = true;
  networking.hostName = "mystix";
  networking.nameservers = [ "2620:0:ccc::2" "2620:0:ccd::2" "2001:4860:4860::8888" "2001:4860:4860::8844" "87.98.175.85" ];
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;
  #networking.wireless.enable = true;

  nix.autoOptimiseStore = true;
  nix.nixPath = [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" ];
  nix.useSandbox = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays = [(import ./overlays.nix) (import /home/nixpkgs-wayland/default.nix)];

  programs.adb.enable = true;
  programs.mosh.enable = true;
  programs.mtr.enable = true;
  programs.nano.nanorc = ''
    set nowrap
    set tabstospaces
    set tabsize 2
  '';
  programs.sway.enable = true;
  programs.sway.extraPackages = with pkgs; [ grim i3status-rust imv kanshi mako redshift-wayland slurp swaybg swayidle swaylock wdisplays wl-clipboard xwayland ];
  #programs.way-cooler.enable = true;

  services.acpid.enable = true;
  services.acpid.handlers.volumeDown = {
    event = "button/volumedown";
    action = "${pkgs.pamixer}/bin/pamixer -d 3";
  };
  services.acpid.handlers.volumeUp = {
    event = "button/volumeup";
    action = "${pkgs.pamixer}/bin/pamixer -i 3";
  };
  services.acpid.handlers.mute = {
    event = "button/mute";
    action = "${pkgs.pamixer}/bin/pamixer -t";
  };
  services.acpid.handlers.cdPlay = {
    event = "cd/play.*";
    action = "${pkgs.mpc_cli}/bin/mpc toggle";
  };
  services.acpid.handlers.cdNext = {
    event = "cd/next.*";
    action = "${pkgs.mpc_cli}/bin/mpc next";
  };
  services.acpid.handlers.cdPrev = {
    event = "cd/prev.*";
    action = "${pkgs.mpc_cli}/bin/mpc prev";
  };

  services.dnsmasq.enable = true;
  services.dnsmasq.servers = config.networking.nameservers;
  services.journald.extraConfig = "SystemMaxUse=100M";
  services.locate.enable = true;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
  '';
  services.mpd.enable = true;
  services.mpd.extraConfig = ''
    metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc,comment"
    restore_paused "yes"

    audio_output {
      type     "pulse"
      name     "MPD"
      server   "127.0.0.1"
    }

    audio_output {
      type                    "fifo"
      name                    "my_fifo"
      path                    "/tmp/mpd.fifo"
      format                  "44100:16:2"
    }
  '';
  services.mpd.musicDirectory = "/home/music";
  services.mpd.network.listenAddress = "any";
  services.mpd.startWhenNeeded = true;
  services.openssh.enable = true;
  services.openssh.startWhenNeeded = true;
  services.privoxy.enable = true;
  #services.redshift.enable = true;
  #services.redshift.latitude = "43.7";
  #services.redshift.longitude = "7.2";
  services.rsyncd = {
    enable = true;
    modules = {
      music = {
        path = "/home/music";
        "read only" = "yes";
      };
    };
  };
  services.smartd.enable = true;
  services.udisks2.enable = true;

  system.autoUpgrade.enable = false;

  systemd.user.services.backup = {
    description = "Backup";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart=[
        "-${pkgs.git}/bin/git -C %h/.config push"
        "-/bin/sh -c '${pkgs.notmuch}/bin/notmuch config list >| %h/.config/notmuch/config_all'"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper create --remote-path=borg1 -x -C lzma \"17994@ch-s011.rsync.net:backup::{utcnow}-{hostname}\" %h/doc %h/feeds %h/images %h/papers %h/prog/archive %h/studies %h/.config %h/.mozilla %h/.task'"
        "-${pkgs.nix}/bin/nix-shell -p borgbackup --run '/home/koral/.config/systemd/user/borg-wrapper prune --remote-path=borg1 -d 30 \"17994@ch-s011.rsync.net:backup\"'"
      ];

      Type = "oneshot";
    };
  };

  systemd.user.services.mailsync = {
    description = "Synchronize IMAP mails";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = [
        "-${pkgs.isync}/bin/mbsync -a"
        "-${pkgs.notmuch}/bin/notmuch new"
      ];
      Type = "oneshot";
    };
  };

  systemd.user.services.cleanup = {
    description = "$HOME clean-up";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart=[
        "${pkgs.coreutils}/bin/chmod -R go-rwx %h/mail %h/papers %h/.gnupg"
        "-${pkgs.coreutils}/bin/mv -u %h/Downloads/* %h/Desktop/* %h"
        "-${pkgs.coreutils}/bin/rm -d %h/Downloads %h/Desktop"
        #/run/current-system/sw/bin/detox -r /home/music
      ];
    };
  };

  systemd.user.timers.backup = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "backup.service";
      OnCalendar = "daily";
    };
  };

  systemd.user.timers.mailsync = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      Unit = "mailsync.service";
      OnBootSec = "1min";
      OnUnitActiveSec = "7min";
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

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "adbusers" "audio" "wheel" "sway" ];
    isNormalUser = true;
    uid = 1000;
  };
}
