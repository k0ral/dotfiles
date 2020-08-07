self: super:

{
  bemenu = super.bemenu.override { x11Support = false; };

  pulseaudio = super.pulseaudio.override {
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  ncmpcpp = super.ncmpcpp.override { visualizerSupport = true; };
}
