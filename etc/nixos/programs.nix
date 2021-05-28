{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ntfs3g
  ];

  programs = {
    adb.enable = true;
    fish.enable = true;
    iftop.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';
  };
}
