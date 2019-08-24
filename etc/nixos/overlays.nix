self: super:

{
  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
  };
}
