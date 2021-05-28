{ config, pkgs, ... }: {

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

  services.gnome3 = {
    evolution-data-server.enable = true;
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
  };

  services.journald.extraConfig = "SystemMaxUse=100M";
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
  '';

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

  services.thermald.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
}
