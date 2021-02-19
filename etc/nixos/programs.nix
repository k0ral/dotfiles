{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Audio
    beets
    flac
    mpc_cli
    ncmpcpp
    ncpamixer
    opusTools
    pamixer
    paprefs
    vorbis-tools

    # CLI
    bat
    direnv
    exa
    fd
    fzf
    gcalcli
    gron
    loop
    navi
    ncurses.dev
    pueue
    ripgrep
    starship
    tldr
    tmux
    tmuxp
    # urlscan
    yank
    zsh

    # Development
    binutils
    cacert
    chromaprint
    cookiecutter
    crex
    dhall-json
    git
    gitAndTools.delta
    gitAndTools.gh
    graphviz
    icu
    jq
    libxml2
    neovim
    nixfmt
    nodePackages.js-beautify
    openssl
    patchelf
    poppler_utils
    pup
    python3
    tig
    z3

    # Filesystem
    atool
    bashmount
    borgbackup
    cryptsetup
    detox
    dfc
    encfs
    file
    libarchive
    libmtp
    libnotify
    ncdu
    ntfs3g
    pv
    rmlint
    rsync
    sshfsFuse
    tree
    unrar
    unzip
    zip

    # GUI
    bemenu
    keynav
    kitty
    # i3lock-fancy
    scrcpy
    wallutils
    xorg.xev

    # Haskell
    haskellPackages.apply-refact
    haskellPackages.dhall
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    # open-haddock haddocset hledger stylish-cabal

    # Media
    exiftool
    ffmpeg
    imagemagickBig
    jpegoptim
    mediainfo
    mkvtoolnix-cli
    mpv
    okular
    pdf2svg

    # Network
    aria2
    arp-scan
    bluez
    bluez-tools
    brave
    ddgr
    elinks
    googler
    httpie
    ldns
    mcabber
    monolith
    mps-youtube
    ncat
    nload
    obexfs
    prettyping
    tcpdump
    tcpflow
    telnet
    thunderbird
    youtube-dl
    w3m
    weechat
    wget

    # Nix
    cachix
    niv
    # nix-du
    nix-top
    nox

    # Python
    python3Packages.grip
    python3Packages.mutagen

    # System
    abduco
    acpi
    alsaUtils
    atop
    cpulimit
    glances
    htop
    light
    lsof
    man
    moreutils
    pciutils
    powertop
    procs
    progress
    ps_mem
    psmisc
    smartmontools
    udiskie
    upower
    usbutils
    utillinux

    # Utils
    anki
    dict
    taskwarrior
    vit
  ];

  programs = {
    adb.enable = true;
    fish.enable = true;
    iftop.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';
    sway.enable = true;
    sway.extraPackages = with pkgs; [
      clipman
      grim
      i3status-rust
      imv
      kanshi
      mako
      slurp
      swaybg
      swayidle
      swaylock
      wdisplays
      wl-clipboard
      wlsunset
      xwayland
    ];
  };
}
