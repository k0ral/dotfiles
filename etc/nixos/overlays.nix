self: super:

{
  pulseaudio = super.pulseaudio.override {
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };

  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
  };
}
