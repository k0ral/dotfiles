{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./system-packages.nix
    ./systemd-user.nix
  ];

  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.supportedFilesystems = [ "zfs" ];

  console.keyMap = "us";

  environment.variables = {
    BEMENU_BACKEND = "wayland";
    BROWSER = "firefox";
    EDITOR = "nvim";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    corefonts # Microsoft free fonts
    font-awesome
    nerdfonts
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

  i18n.defaultLocale = "en_US.UTF-8";

  networking.firewall.allowedTCPPorts = [ 873 6600 ];
  networking.enableIPv6 = true;
  networking.hostName = "mystix";
  networking.nameservers = [ "2620:0:ccc::2" "2620:0:ccd::2" "2001:4860:4860::8888" "2001:4860:4860::8844" "87.98.175.85" ];
  networking.networkmanager.enable = true;
  networking.tcpcrypt.enable = true;

  nix.autoOptimiseStore = true;
  nix.nixPath =
    [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" ];
  nix.useSandbox = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays =
    [ (import ./overlays.nix) (import /home/nixpkgs-wayland/default.nix) ];

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
    redshift-wayland
    slurp
    swaybg
    swayidle
    swaylock
    wdisplays
    wl-clipboard
    xwayland
  ];

  services.acpid.enable = true;
  services.acpid.handlers = {
    volumeDown = {
      event = "button/volumedown";
      action = "${pkgs.pamixer}/bin/pamixer -d 3";
    };
    volumeUp = {
      event = "button/volumeup";
      action = "${pkgs.pamixer}/bin/pamixer -i 3";
    };
    mute = {
      event = "button/mute";
      action = "${pkgs.pamixer}/bin/pamixer -t";
    };
    cdPlay = {
      event = "cd/play.*";
      action = "${pkgs.mpc_cli}/bin/mpc toggle";
    };
    cdNext = {
      event = "cd/next.*";
      action = "${pkgs.mpc_cli}/bin/mpc next";
    };
    cdPrev = {
      event = "cd/prev.*";
      action = "${pkgs.mpc_cli}/bin/mpc prev";
    };
  };

  services.dnsmasq = {
    enable = true;
    servers = config.networking.nameservers;
  };

  services.journald.extraConfig = "SystemMaxUse=100M";
  services.locate.enable = true;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
  '';

  services.lorri.enable = true;

  services.mpd = {
    enable = true;
    extraConfig = ''
      metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc,comment"
      restore_paused "yes"
      #replaygain "auto"

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
    musicDirectory = "/home/music";
    network.listenAddress = "any";
    startWhenNeeded = true;
  };

  services.openssh.enable = true;
  services.openssh.startWhenNeeded = true;
  services.privoxy.enable = true;
  services.smartd.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    systemService = true;
    declarative.folders = {
      "/home/music" = {
        id = "music";
        type = "sendonly";
      };
    };
  };

  services.udisks2.enable = true;

  system.autoUpgrade.enable = false;

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "adbusers" "audio" "wheel" "sway" ];
    isNormalUser = true;
    uid = 1000;
  };
}
