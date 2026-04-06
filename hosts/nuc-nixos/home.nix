{ pkgs, inputs, ... }:
{
  home.stateVersion = "26.05";
  imports = [
    ./../../modules/ghostty.nix
    ./../../modules/neovim.nix
    ./../../modules/tmux.nix
    ./../../modules/shell.nix
    inputs.noctalia.homeModules.default
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
    programs.opencode.enable = true;
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
    programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here
        bar = {
          barType = "floating";
          density = "comfortable";
          position = "top";
          showCapsule = true;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "name";
              }
            ];
            center = [
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
            right = [
              {
                id = "plugin:tailscale";
                defaultSettings.terminalCommand = "ghostty";
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Tray";
                colorizeIcons = true;
                drawerEnabled = true;
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Gruvbox";
        location = {
          monthBeforeDay = true;
          name = "New York, US";
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      systemd.extraCommands = [ "noctalia-shell" ];
      settings = {
        input.kb_options = "caps:ctrl_modifier";
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
        };
        decoration = {
          rounding = 20;
          rounding_power = 2;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 2;
            vibrancy = 0.1696;
          };
        };

        "$mod" = "SUPER";

        bind = [
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
          "$mod, Return, exec, ghostty"
          "$mod, Space, exec, noctalia-shell ipc call launcher toggle"
          "$mod, w, killactive,"
          "$mod, m, fullscreen,"
          "$mod, f, togglefloating,"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"
        ];

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"
        ];

        bindl = [
          ",XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
          ",XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
          ",XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ];
      };

      extraConfig = ''
        env= HYPRCURSOR_THEME, Bibata-Modern-Classic
        env= HYPRCURSOR_SIZE, 24
        env= XCURSOR_THEME, Bibata-Modern-Classic
        env= XCURSOR_SIZE, 24
      '';
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
