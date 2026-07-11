{ pkgs, ... }:
{
  home.stateVersion = "26.11";
  imports = [
    ./../../modules/ghostty.nix
    ./../../modules/neovim.nix
    ./../../modules/tmux.nix
    ./../../modules/shell.nix
    ./../../modules/agent.nix
    ./../../modules/hyprland.nix
  ];
  home.packages = with pkgs; [
    tree
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
    fastfetch
    perl
    gcc
    fasd
    obsidian
    img2pdf
    eog
    libva-utils
    tradingview
    remmina
    devenv
    (llm.withPlugins { llm-perplexity = true; llm-gemini = true;})
    glow
    d2
    dua
    duf
    just
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
            family = "JetBrainsMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Italic";
          };
          size = 12;
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
    programs.rofi = {
      enable = true;
      theme = "gruvbox-dark";
      font = "hack 10";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      extraConfig = {
          show-icons = true;
          icon-theme = "Papirus-Dark";
          modi = "drun,run";
        };
      };
    programs.firefox = {
      enable = true;
      profiles = {
        myfox = {
          settings = {
            "app.update.auto" = false;
            "app.normandy.first_run" = false;
            "browser.startup.homepage" = "https://nixos.org";
            "browser.shell.checkDefaultBrowser" = false;
            "browser.tabs.warnOnClose" = false;
            "trailhead.firstrun.didSeeAboutWelcome" = true;
          };
        };
      };
    };
    programs.qutebrowser = {
      enable = true;
      keyBindings = {
        normal = {
          "h" = "close";
          ",m" = "hint links spawn mpv {hint-url}";
        };
      };
      searchEngines = {
        g = "https://www.google.com/search?hl=en&q={}";
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        yt = "https://www.youtube.com/results?search_query={}";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://nixos.wiki/index.php?search={}";
        np = "https://search.nixos.org/packages?query={}&from=0&size=30&sort=relevance&channel=unstable";
        no = "https://search.nixos.org/options?query={}&from=0&size=30&sort=relevance&channel=unstable";
        lr = "https://search.azlyrics.com/search.php?q={}";
        tw = "https://twitter.com/search?q={}&src=typed_query";
        rd = "https://www.reddit.com/search/?q={}";
      };
      extraConfig =
        ''
          config.set("content.private_browsing", True);
          config.set("tabs.tabs_are_windows", True);
          config.set("url.start_pages", [ "about:blank" ]);
          config.set("colors.webpage.darkmode.enabled", True);
          config.set("colors.webpage.darkmode.policy.page", "always");
          config.load_autoconfig(False)
        '';
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
    services.nextcloud-client = {
      enable = true;
    };
    services.blueman-applet = {
      enable = true;
    };
    services.pasystray = {
      enable = true;
    };
    services.network-manager-applet = {
      enable = true;
    };
    gtk = {
      enable = true;
      font = {
        name = "hack 10";
      };
      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-nord
        fcitx5-gtk
      ];
    };
}
