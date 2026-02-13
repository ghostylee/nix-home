{ pkgs, ... }:
{
  home.stateVersion = "26.05";
  imports = [
    ./../../modules/neovim.nix
    ./../../modules/tmux.nix
    ./../../modules/shell.nix
  ];
  home.packages = with pkgs; [
    tree
    silver-searcher
    hexyl
    minicom
    unzip
    gitRepo
    file
    nodejs
    dconf
    ctags
    libnotify
    vifm
    wget
    feh
    neofetch
    perl
    gcc
    fasd
    ookla-speedtest
    yt-dlp
    tailscale
  ];
    programs.home-manager.enable = true;
    programs.gpg.enable = true;
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
    programs.alacritty = {
      enable = true;
      settings = {
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          normal = {
            family = "BlexMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "BlexMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "BlexMono Nerd Font Mono";
            style = "Italic";
          };
          size = 20;
        };
        colors = {
          primary.background = "0x282828";
          primary.foreground = "0xebdbb2";

          normal = {
            black   = "0x282828";
            red     = "0xcc241d";
            green   = "0x98971a";
            yellow  = "0xd79921";
            blue    = "0x458588";
            magenta = "0xb16286";
            cyan    = "0x689d6a";
            white   = "0xa89984";
          };

          bright = {
            black   = "0x928374";
            red     = "0xfb4934";
            green   = "0xb8bb26";
            yellow  = "0xfabd2f";
            blue    = "0x83a598";
            magenta = "0xd3869b";
            cyan    = "0x8ec07c";
            white   = "0xebdbb2";
          };

        };
        window.opacity = 0.9;
        general.live_config_reload = true;
      };
    };
}
