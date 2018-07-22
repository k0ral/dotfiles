self: super:

let
  stVersion = "0.8.1";

  alphaPatch = self.fetchpatch {
    name = "st-alpha.patch";
    url = "https://st.suckless.org/patches/alpha/st-alpha-${stVersion}.diff";
    sha256 = "18iw0bzmagcchlf5m5dfvdryn47kpdbcs1j1waq8vl1w2wvcg5al";
  };

  clipboardPatch = self.fetchpatch {
    name = "clipboard.patch";
    url = "https://st.suckless.org/patches/clipboard/st-clipboard-${stVersion}.diff";
    sha256 = "0gdjgzg2a98fph4sn4w210p39401mm4imkrllfyhc836bjyhi5pc";
  };

  hidecursorPatch = self.fetchpatch {
    name = "hidecursor.patch";
    url = "https://st.suckless.org/patches/hidecursor/st-hidecursor-${stVersion}.diff";
    sha256 = "02b4h375c2vd79f7cagki5fnx1ipygywlxn25c62kg529d7zfck0";
  };

  scrollbackPatch = self.fetchpatch {
    name = "scrollback.patch";
    url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.diff";
    sha256 = "0q7yisna58x62hdsdd3cnlnf1rbjzxgy9a3s725vahp0yavrwj61";
  };

in
{
  st = super.st.override {
    conf = import ./st.nix;
    patches = [alphaPatch clipboardPatch hidecursorPatch scrollbackPatch];
  };
}
