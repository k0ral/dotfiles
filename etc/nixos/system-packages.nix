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
    urlscan
    yank
    zsh

    # Development
    binutils
    cacert
    chromaprint
    crex
    git
    gitAndTools.diff-so-fancy
    gitAndTools.gh
    graphviz
    icu
    jq
    libxml2
    neovim
    nixfmt
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
    wallutils
    xorg.xev

    # Haskell
    haskellPackages.apply-refact
    haskellPackages.dhall
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    # open-haddock haddocset hledger stylish-cabal

    # Media
    evince
    exiftool
    ffmpeg
    imagemagick
    jpegoptim
    mediainfo
    mkvtoolnix-cli
    mpv
    pdf2svg
    rtv

    # Network
    aria2
    arp-scan
    bluez
    bluez-tools
    ddgr
    discord
    elinks
    firefox-wayland
    googler
    httpie
    iftop
    isync
    ldns
    mcabber
    mps-youtube
    msmtp
    ncat
    neomutt
    nload
    notmuch
    obexfs
    prettyping
    tcpdump
    tcpflow
    telnet
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
    dict
    taskwarrior
    vit
  ];
}
