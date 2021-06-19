{ pkgs ? import <nixpkgs> {} }:

with pkgs; [
  # Aliases
  cut-from
  cut-to
  find-videos
  fzf-git-branch
  fzf-git-changeset
  fzf-git-diff
  fzf-git-tag
  fzf-pid

  # Audio
  cava
  flac
  mpc_cli
  ncpamixer
  opusTools
  pamixer
  paprefs
  pavucontrol
  vorbis-tools

  # CLI
  asciinema
  cmatrix
  fd
  gron
  loop
  navi
  ncurses.dev
  pihello
  pueue
  ripgrep
  starship
  tldr
  # urlscan
  xdg_utils
  yank

  # Development
  binutils
  cacert
  chromaprint
  cookiecutter
  crex
  dhall-json
  git
  gitAndTools.delta
  graphviz
  icu
  libxml2
  nixfmt
  nodePackages.js-beautify
  openssl
  patchelf
  poppler_utils
  pup
  python3
  shellcheck
  tig
  z3
  zeal

  # Filesystem
  atool
  bashmount
  borgbackup
  cryptsetup
  detox
  dfc
  encfs
  file
  ipfs
  libarchive
  libmtp
  libnotify
  ncdu
  # ntfs3g
  pv
  rmlint
  rpi-imager
  rsync
  sshfsFuse
  tree
  # unrar
  unzip
  zip

  # GUI
  bemenu
  drawio
  evolution
  keynav
  # i3lock-fancy
  scrcpy
  swappy
  swaylock-effects
  wallutils
  xorg.xev

  # Haskell
  haskellPackages.apply-refact
  haskellPackages.dhall
  # haskellPackages.ghcide
  haskellPackages.hlint
  haskellPackages.stylish-haskell
  # open-haddock haddocset hledger stylish-cabal

  # Media
  discord
  exiftool
  ffmpeg
  gimp
  imagemagickBig
  jpegoptim
  libreoffice
  mediainfo
  mkvtoolnix-cli
  mpv
  okular
  pdf2svg
  pdftk

  # Network
  arp-scan
  bluez
  bluez-tools
  brave
  ddgr
  elinks
  freetube
  giara
  gnirehtet
  googler
  httpie
  ldns
  mcabber
  monolith
  ncat
  nload
  obexfs
  prettyping
  signal-desktop
  speedtest-cli
  tcpdump
  tcpflow
  telnet
  youtube-dl
  w3m
  weechat
  wget

  # Nix
  cachix
  nix-du
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
  bpytop
  cpulimit
  docker
  hdparm
  light
  lm_sensors
  lsof
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
  aspell
  aspellDicts.fr
  aspellDicts.en
  dict
  unipicker
  taskwarrior

  # Wayland
  clipman
  grim
  i3status-rust
  imv
  kanshi
  slurp
  swaybg
  swayidle
  # swaylock
  wdisplays
  wl-clipboard
  wlr-randr
  wlsunset
  xwayland
]
