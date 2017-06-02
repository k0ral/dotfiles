# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  environment.systemPackages = 
    let devPack = with pkgs; [ ack asciidoc-full-with-plugins asciidoctor awscli binutils bundler cabal-install cacert chromaprint emacs icu git grc gnumake libxml2 mercurial octave pkgconfig ruby urlview ];
        fsPack = with pkgs; [ atool bashmount detox dfc duplicity encfs file libmtp libnotify ncdu ntfs3g rmlint rsync sshfsFuse tree unrar unzip zip ];
        graphicalPack = with pkgs; [ arandr dmenu2 dunst dzen2 scrot slock termite wmctrl xclip xorg.xbacklight xorg.xkill ];
        mediaPack = with pkgs; [ apvlv beets feh ffmpeg handbrake imagemagick jpegoptim lsdvd mediainfo mkvtoolnix-cli mpc_cli mpd mpv ncmpcpp sxiv ];
        netPack = with pkgs; [ aria2 bind conkeror elinks firefox isync mutt telnet transmission w3m weechat wget ];
        nixPack = with pkgs; [ cabal2nix nix-repl nox ];
        haskellPack = with pkgs.haskell.packages.ghc801; [ apply-refact ghc ghc-mod haddocset happy hasktags hindent hledger hlint stylish-haskell xmobar ]; # open-haddock
        pythonPack = with pkgs.python3Packages; [ glances grip udiskie youtube-dl ]; # mps-youtube
        systemPack = with pkgs; [ abduco acpi fish htop lsof man numlockx pciutils powertop progress rfkill smartmontools ];
    in devPack ++ fsPack ++ graphicalPack ++ mediaPack ++ netPack ++ nixPack ++ pythonPack ++ systemPack ++ haskellPack;


  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts  # Micrsoft free fonts
    inconsolata  # monospaced
    source-code-pro
    unifont # some international languages
    ];
  fonts.fontconfig.defaultFonts.monospace = [ "Inconsolata" ];


  hardware.bumblebee.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull.override { gconfSupport = false; };

  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };


  networking.hostName = "mystix";
  networking.nameservers = [ "2620:0:ccc::2" "2620:0:ccd::2" "2001:4860:4860::8888" "2001:4860:4860::8844" "87.98.175.85" ];
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;
  #networking.wireless.enable = true;

  nix.nixPath = [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" ];
  nixpkgs.config.allowUnfree = true;


  # Override package
  # nixpkgs.config.packageOverrides = pkgs : rec { 
  #   kde4 = pkgs.kde410; 
  # };

  security.setuidPrograms = [ "slock" ];

  services.acpid.enable = true;
  services.acpid.handlers.volumeDown = {
    event = "button/volumedown";
    action = "${pkgs.alsaUtils}/bin/amixer -c0 set Master 3%-";
  };
  services.acpid.handlers.volumeUp = {
    event = "button/volumeup";
    action = "${pkgs.alsaUtils}/bin/amixer -c0 set Master 3%+";
  };
  services.acpid.handlers.mute = {
    event = "button/mute";
    action = "${pkgs.alsaUtils}/bin/amixer -c0 set Master toggle";
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

  services.xserver.autorun = true;
  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "fr";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.synaptics.enable = true;
  services.xserver.xkbVariant = "latin9";
  services.xserver.windowManager.default = "xmonad";
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;


  system.autoUpgrade.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "16.03";

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    uid = 1000;
  };
}
