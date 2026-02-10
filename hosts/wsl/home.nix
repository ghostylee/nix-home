{ pkgs, ... }:
{
  home.stateVersion = "26.05";
  home.username = "song";
  home.homeDirectory = "/home/song";
  imports = [
    ./../../modules/neovim.nix
    ./../../modules/tmux.nix
    ./../../modules/shell.nix
  ];
  home.packages = with pkgs; [
    tree
    silver-searcher
    hexyl
    pamixer
    minicom
    unzip
    gitRepo
    file
    ncdu
    nodejs
    dconf
    thunar
    libnotify
    brightnessctl
    vifm
    evince
    wget
    feh
    neofetch
    perl
    gcc
    fasd
    libva-utils
    devenv
    tio
  ];
    programs.home-manager.enable = true;
    programs.git = {
      enable = true;
      settings = {
        user.name = "Song Li";
        user.email = "ghosty.lee.1984@gmail.com";
        alias = {
          co = "checkout";
          cob = "checkout -b";
          br = "branch";
          st = "status";
          log-fancy = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative";
          log-nice = "log --graph --decorate --pretty=oneline --abbrev-commit";
          master = "checkout master";
          cm = "commit -m";
          cam = "commit -a -m";
        };
        pull = {
          ff = "only";
        };
      };
    };
}
