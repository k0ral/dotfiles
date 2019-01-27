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
    let devPack = with pkgs; [ ack asciidoc asciidoctor atom binutils bundler cabal-install cacert chromaprint git gnumake grc icu libxml2 mercurial openssl pkgconfig poppler_utils python3 urlview zeal ];
        fsPack = with pkgs; [ atool bashmount borgbackup detox dfc duplicity encfs file libmtp libnotify ncdu ntfs3g rmlint rsync sshfsFuse tree unrar unzip zip ];
        graphicalPack = with pkgs; [ arandr dmenu2 dunst dzen2 i3lock-fancy st wmctrl xclip xorg.xbacklight xorg.xkill ];
        mediaPack = with pkgs; [ beets feh ffmpeg imagemagick jpegoptim lsdvd mediainfo mkvtoolnix-cli mpc_cli mpd mpv pamixer ncmpcpp sxiv zathura ];
        netPack = with pkgs; [ aria2 bind bluez bluez-tools buku conkeror elinks firefox isync neomutt notmuch obexfs telnet w3m weechat wget ];
        nixPack = with pkgs; [ cabal2nix nix-repl nox ];
        haskellPack = with pkgs.haskell.packages.ghc802; [ apply-refact ghc ghc-mod hakyll happy hasktags hlint stylish-haskell xmobar ]; # open-haddock haddocset hledger hindent
        pythonPack = with pkgs.python3Packages; [ glances grip udiskie youtube-dl ]; # mps-youtube
        systemPack = with pkgs; [ abduco acpi fish htop lsof man numlockx pciutils powertop progress psmisc rfkill smartmontools usbutils ];
    in devPack ++ fsPack ++ graphicalPack ++ mediaPack ++ netPack ++ nixPack ++ pythonPack ++ systemPack ++ haskellPack;


  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts  # Micrsoft free fonts
    fira-code
    hasklig
    inconsolata  # monospaced
    iosevka
    source-code-pro
    unifont # some international languages
    ];
  fonts.fontconfig.defaultFonts.monospace = [ "Inconsolata" ];


  hardware.bluetooth.enable = true;
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull.override { gconfSupport = false; };

  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };


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


  # Override package
  # nixpkgs.config.packageOverrides = pkgs : rec { 
  #   kde4 = pkgs.kde410; 
  # };

  security.setuidPrograms = [ "slock" ];
  programs.nano.nanorc = ''
    set nowrap
    set tabstospaces
    set tabsize 2
  '';
  programs.sway.enable = true;
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

  services.atd.enable = true;
  services.compton.enable = true;
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
  services.openssh.enable = true;
  services.openssh.startWhenNeeded = true;
  services.redshift.enable = true;
  services.redshift.latitude = "43.7";
  services.redshift.longitude = "7.2";
  services.smartd.enable = true;
  services.udisks2.enable = true;

  system.autoUpgrade.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "16.03";

  systemd.user.services.mpd = {
    description = "Music Player Daemon";
    serviceConfig = {
      ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon";
      ExecStop = "${pkgs.mpd}/bin/mpd --kill";
      PIDFile = "%h/.config/mpd/pid";
      Restart = "always";
      RestartSec = 30;
    };
    wantedBy = [ "default.target" ];
  };

  systemd.user.sockets.mpd = {
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = 6600;
    };
  };

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "wheel" "sway" ];
    isNormalUser = true;
    uid = 1000;
  };

  # Android development
  # environment.systemPackages = with pkgs; [ androidenv.platformTools heimdall ];
  # services.udev.packages = [ pkgs.android-udev-rules ];
  # users.extraGroups.plugdev = { };
  # users.extraUsers.koral.extraGroups = [ "plugdev" ];
}
