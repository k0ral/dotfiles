{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./programs.nix ./services.nix ];

  boot = {
    cleanTmpDir = true;
    kernelModules = [ "coretemp" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    supportedFilesystems = [ "zfs" ];
  };

  console.keyMap = "us";

  environment.variables = {
    BEMENU_BACKEND = "wayland";
    BROWSER = "brave";
    EDITOR = "nvim";
    FZF_DEFAULT_COMMAND = "fd --type f";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  fonts = {
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      # encode-sans
      font-awesome
      nerdfonts
      # noto-fonts
      # google-fonts
      # source-han-sans
      # source-han-mono
      # source-han-serif
      ubuntu_font_family
      unifont # some international languages
    ];
    fontconfig.defaultFonts.monospace = [ "Hack" ];
  };

  hardware = {
    bluetooth.enable = true;

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      tcp.enable = true;
      tcp.anonymousClients.allowAll = true;
      zeroconf.discovery.enable = true;
      zeroconf.publish.enable = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.allowedTCPPorts = [ 873 6600 ];
    enableIPv6 = true;
    hostId = "01ed4135";
    hostName = "mystix";
    networkmanager.enable = true;
  };

  nix = {
    autoOptimiseStore = true;
    binaryCaches = [ "https://cache.nixos.org/" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    nixPath = [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "home-manager=/home/home-manager" ];
    package = pkgs.nixFlakes;
    trustedUsers = [ "@wheel" ];
    useSandbox = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays = [ (import ./overlays.nix) ];

  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  security.pam.services.sddm.enableGnomeKeyring = true;

  system.autoUpgrade.enable = false;

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "adbusers" "audio" "wheel" "sway" ];
    isNormalUser = true;
    shell = pkgs.fish;
    uid = 1000;
  };
}
