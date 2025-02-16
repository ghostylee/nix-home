{ pkgs, ... }:
{
  home.stateVersion = "25.05";
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
    gitAndTools.diff-so-fancy
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
    nxpmicro-mfgtools
    gcc
    fasd
    ookla-speedtest
    yt-dlp
  ];
    programs.home-manager.enable = true;
    programs.gpg.enable = true;
    programs.git = {
      enable = true;
      userName = "Song Li";
      userEmail = "ghosty.lee.1984@gmail.com";
      signing = {
        signByDefault = false;
        format = "openpgp";
        key = "B1E0152BFCF886EC";
      };
      aliases = {
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
      extraConfig = {
        core = {
          pager = "diff-so-fancy | less --tabs=4 -RFX";
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
    programs.newsboat = {
      enable = true;
      autoReload = true;
      browser = "qutebrowser";
      extraConfig =
        ''
          download-path "~/Downloads/podcasts/%n"
          player mpv
          article-sort-order date-asc

          color background          white   black
          color listnormal          white   black
          color listfocus           black   white   bold
          color listnormal_unread   black   yellow
          color listfocus_unread    black   yellow   bold
          color info                yellow  black    bold
          color article             white   black

          bind-key j down
          bind-key k up
          bind-key G end
          bind-key g home
          bind-key l open
          bind-key h quit
          bind-key u toggle-article-read
          bind-key n next-unread
          bind-key N prev-unread
          bind-key l open-in-browser article
          bind-key J next-feed       articlelist
          bind-key K prev-feed       articlelist
          macro m set browser "mpv %u"; open-in-browser-and-mark-read ; set browser "qutebrowser"
        '';
      urls = [
        { tags = [ "tech" ]; url = "https://news.ycombinator.com/rss"; }
        { tags = [ "tech" ]; url = "https://lwn.net/headlines/newrss"; }
        { tags = [ "tech" ]; url = "https://www.phoronix.com/rss.php"; }
        { tags = [ "tech" ]; url = "http://feeds.feedburner.com/cnx-software/blog"; }
        { tags = [ "tech" ]; url = "https://martinfowler.com/feed.atom"; }
        { tags = [ "tech" ]; url = "https://blog.rust-lang.org/feed"; }
        { tags = [ "tech" ]; url = "https://weekly.nixos.org/feeds/all.rss.xml"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfX55Sx5hEFjoC3cNs6mCUQ"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCs_tLP3AiwYKwdUHpltJPuA"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC4-GrpQBx6WCGwmwozP744Q"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCTdw38Cw6jcm0atBPA39a0Q"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?user=fosdemtalks"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCIxsmRWj3-795FMlrsikd3A"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?user=MarakanaTechTV"; }
        { tags = [ "talk" ]; url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCkAQCw5_sIZmj2IkSrNy00A"; }
      ];
    };
}
