self: super:

{
  bemenu = super.bemenu.override { x11Support = false; };

  pulseaudio = super.pulseaudio.override {
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  nerdfonts = super.nerdfonts.override { fonts = [ "FiraCode" ]; };
}
