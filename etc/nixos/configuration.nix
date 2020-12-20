{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./services.nix
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

  fonts.enableGhostscriptFonts = true;
  fonts.fontDir.enable = true;
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
  nix.binaryCaches = [ "https://cache.nixos.org/" ];
  nix.nixPath =
    [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" ];
  nix.trustedUsers = [ "@wheel" ];
  nix.useSandbox = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays =
    [ (import ./overlays.nix) (import /home/nixpkgs-wayland/default.nix) ];

  system.autoUpgrade.enable = false;

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "adbusers" "audio" "wheel" "sway" ];
    isNormalUser = true;
    uid = 1000;
  };
}
