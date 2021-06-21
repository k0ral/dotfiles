{ config, pkgs ? import <nixpkgs> {}, ... }:

{
  home.username = "koral";
  home.homeDirectory = "/home/koral";
  home.packages = import ./packages.nix { inherit pkgs; };
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/$UID";
  home.stateVersion = "21.05";

  news.display = "silent";

  nixpkgs.overlays = [ (self: super: {
    bemenu = super.bemenu.override { x11Support = false; };
    pihello = import ./pihello.nix { inherit self super; };
    cut-from = super.writeScriptBin "cut-from" (builtins.readFile ./alias/cut-from.sh);
    cut-to = super.writeScriptBin "cut-to" (builtins.readFile ./alias/cut-to.sh);
    find-videos = super.writeScriptBin "find-videos" (builtins.readFile ./alias/find-videos.sh);
    fzf-git-branch = super.writeScriptBin "fzf-git-branch" (builtins.readFile ./alias/fzf-git-branch.sh);
    fzf-git-changeset = super.writeScriptBin "fzf-git-changeset" (builtins.readFile ./alias/fzf-git-changeset.sh);
    fzf-git-diff = super.writeScriptBin "fzf-git-diff" (builtins.readFile ./alias/fzf-git-diff.sh);
    fzf-git-tag = super.writeScriptBin "fzf-git-tag" (builtins.readFile ./alias/fzf-git-tag.sh);
    fzf-pid = super.writeScriptBin "fzf-pid" (builtins.readFile ./alias/fzf-pid.sh);
  })];

  gtk = import ./gtk.nix { inherit pkgs; };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  programs = {
    aria2.enable = true;
    aria2.extraConfig = builtins.readFile ./aria2/aria2.conf;
    bat.enable = true;
    beets = import ./beets.nix { inherit pkgs; };
    broot.enable = true;
    command-not-found.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    exa.enable = true;
    exa.enableAliases = true;
    fzf.enable = true;
    gh.enable = true;
    gh.gitProtocol = "ssh";
    home-manager.enable = true;
    jq.enable = true;
    kitty.enable = true;
    kitty.extraConfig = builtins.readFile ./kitty/kitty.conf;
    mako.enable = true;
    man.enable = true;
    mpv = import ./mpv.nix { inherit pkgs; };
    ncmpcpp = import ./ncmpcpp.nix { inherit pkgs; };
    neovim.enable = true;
    neovim.extraConfig = builtins.readFile ./nvim/init.vim;
    tmux = import ./tmux.nix { inherit pkgs; };
  };

  services = {
    mpd = import ./mpd.nix { inherit pkgs; };
    pulseeffects.enable = true;
    pulseeffects.package = pkgs.pulseeffects-pw;
  };

  # systemd.user.extraConfig = ''
  #   DefaultEnvironment="PATH=/run/current-system/sw/bin"
  # '';

  systemd.user.services = import ./systemd-services.nix { inherit pkgs; };
  systemd.user.timers = import ./systemd-timers.nix { inherit pkgs; };

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./sway/config;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
  };

  xdg.configFile = {
    "ack/ackrc".source = ./ack/ackrc;
    "bpytop/bpytop.conf".source = ./bpytop/bpytop.conf;
    "fish/config.fish".source = ./fish/config.fish;
    "git/gitconfig".source = ./git/gitconfig;
    "kanshi/config".source = ./kanshi/config;
    "nvim/init.vim".source = ./nvim/init.vim;
    "stylish-haskell/config.yaml".source = ./stylish-haskell/config.yaml;
    "starship.toml".source = ./starship.toml;
    "sway/capture-screen.sh".source = ./sway/capture-screen.sh;
    "sway/commands".source = ./sway/commands;
    "sway/statusbar.toml".source = ./sway/statusbar.toml;
    "sway/switch-window.sh".source = ./sway/switch-window.sh;
  };

  xdg.dataFile = {
    "navi/cheats/my.cheat".source = ./navi/my.cheat;
  };
}
