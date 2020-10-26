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
    fish
    fzf
    gcalcli
    grc
    gron
    loop
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
    crex
    dhall-json
    git
    gitAndTools.diff-so-fancy
    gitAndTools.gh
    graphviz
    icu
    jq
    libxml2
    neovim
    nixfmt
    nodejs
    openssl
    patchelf
    pup
    poppler_utils
    python3
    tig
    wkhtmltopdf
    z3

    # Filesystem
    atool
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
    rtv

    # Network
    aria2
    arp-scan
    bluez
    bluez-tools
    ddgr
    elinks
    firefox-wayland
    googler
    httpie
    iftop
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
    python3Packages.youtube-dl

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

  programs.adb.enable = true;
  programs.mosh.enable = true;
  programs.mtr.enable = true;
  programs.nano.nanorc = ''
    set nowrap
    set tabstospaces
    set tabsize 2
  '';
  programs.sway.enable = true;
  programs.sway.extraPackages = with pkgs; [
    clipman
    grim
    i3status-rust
    imv
    kanshi
    mako
    #redshift-wayland
    slurp
    swaybg
    swayidle
    swaylock
    wdisplays
    wl-clipboard
    xwayland
  ];

}
