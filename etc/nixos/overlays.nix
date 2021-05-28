self: super:

{
  nerdfonts = super.nerdfonts.override { fonts = [ "FiraCode" ]; };

  pulseaudio = super.pulseaudio.override {
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };
}
