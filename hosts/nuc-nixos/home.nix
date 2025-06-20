{ pkgs, ... }:
{
  home.stateVersion = "24.11";
  imports = [
    ./../../modules/ghostty.nix
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
    xfce.thunar
    libnotify
    brightnessctl
    vifm
    evince
    wget
    feh
    neofetch
    perl
    nxpmicro-mfgtools
    gcc
    fasd
    obsidian
    img2pdf
    eog
    libva-utils
    tradingview
    remmina
  ];
    programs.home-manager.enable = true;
    programs.gpg.enable = true;
    programs.git = {
      enable = true;
      userName = "Song Li";
      userEmail = "ghosty.lee.1984@gmail.com";
      difftastic = {
        enable = true;
        background = "dark";
        color = "always";
        display = "inline";
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
      package = pkgs.rofi-wayland;
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
    programs.mpv = {
      enable = true;
      bindings = {
        h = "quit";
      };
      config = {
        autofit = "90%";
        font = "Source Sans Pro";
      };
    };
    programs.password-store = {
      enable = true;
    };
    programs.browserpass = {
      enable = true;
      browsers = ["firefox"];
    };
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;

          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = ["tray"];

          "hyprland/workspaces" = {
            format = "{name}";
          };
          tray = {
            icon-size = 21;
            spacing = 10;
          };
          clock = {
            interval = 60;
            format = "{:%H:%M}";
            max-length = 25;
          };
        };
      };
      style = ''
        * {
          border: none;
          border-radius: 0px;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16px;
          min-height: 0;
          color: #ebdbb2;
        }
        window#waybar {
          background: @theme_base_color;
          border-bottom: 1px solid @unfocused_borders;
          color: @theme_text_color;
        }
        #workspaces button.active {
          background: #689d6a;
        }
        #clock {
          color: #d79921;
          font-weight: bold;
        }
      '';
    };
    xsession = {
      enable = true;
      initExtra = " setxkbmap -option caps:ctrl_modifier ";
      windowManager.bspwm = {
          enable = true;
          monitors = {
            "HDMI-5" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
          };
          settings = {
            border_width = 2;
            window_gap = 12;
            split_ratio = 0.52;
            borderless_monocle = true;
            gapless_monocle = true;
          };
          rules = {
            "Firefox" = {
              desktop = "^2";
              follow = true;
            };
          };
          startupPrograms = [
            "systemctl restart --user polybar"
            ];
        };
      };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        input.kb_options = "caps:ctrl_modifier";
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
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
          "$mod, Space, exec, rofi -show drun"
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
          ",XF86AudioMute, exec, pamixer -t"
          ",XF86AudioRaiseVolume, exec, pamixer -i 5"
          ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ];
      };

      extraConfig = ''
        env= HYPRCURSOR_THEME, Bibata-Modern-Classic
        env= HYPRCURSOR_SIZE, 24
        env= XCURSOR_THEME, Bibata-Modern-Classic
        env= XCURSOR_SIZE, 24
      '';
    };
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + Return" = "alacritty";
        "super + @space" = "rofi -show drun";
        "super + shift + s" = "flameshot gui";
        "XF86AudioMute" = "pamixer -t";
        "XF86Audio{Raise,Lower}Volume" = "pamixer -{i,d} 5";
        "XF86MonBrightnessUp" = "brightnessctl s +10%";
        "XF86MonBrightnessDown" = "brightnessctl s 10%-";
        "super + alt + {q,r}" = "bspc {quit,wm -r}";
        "super + {_,shift + }w" = "bspc node -{c,k}";
        "super + m" = "bspc desktop -l next";
        "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
        "super + g" = "bspc node -s biggest";
        "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";
        "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
        "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";
        "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
        "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
        "super + {grave,Tab}" = "bspc {node,desktop} -f last";
        "super + {o,i}" = "bspc wm -h off; bspc node {older,newer} -f; bspc wm -h on";
        "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
        "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
        "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
        "super + ctrl + space" = "bspc node -p cancel";
        "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
        "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
        "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
        "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      };
    };
    services.polybar = {
      enable = false;
      config = {
        "colors" = {
          bg = "#282828";
          fg = "#ebdbb2";
          black = "#282828";
          darkgrey = "#928374";
          darkred = "#cc241d";
          red = "#fb4934";
          darkgreen = "#98971a";
          green = "#b8bb26";
          darkyellow = "#d79921";
          yellow = "#fabd2f";
          darkblue = "#458588";
          blue = "#83a598";
          darkmegenta = "#b16286";
          magenta = "#d3869b";
          darkcyan = "#689d6a";
          cyan = "#8ec07c";
          lightgrey = "#a89984";
          white = "#ebdbb2";
          ac = "#fabd2f";
        };

        "global/wm" = {
          margin-bottom = 0;
          margin-top = 0;
        };

        "bar/main" = {
          width = "100%";
          height = 24;
          radius = 0;
          modules-left = "bspwm";
          modules-center = "date";
          modules-right = "tray";
          font-0 = "FiraMono Nerd Font:size=12:weight=bold;3";
          font-1 = "FiraMono Nerd Font Mono:pixelsize=24;6";
          background = "\${colors.bg}";
          foreground = "\${colors.fg}";
          separator = " ";
        };

        "module/tray" = {
          type = "internal/tray";
          format-margin = "8px";
          tray-spacing = "8px";
        };

        "module/date" = {
          type = "internal/date";
          internal = 30;
          time = "%Y-%m-%d %H:%M";
          label = "%time%";
          format-background = "\${colors.bg}";
          format-foreground = "\${colors.yellow}";
        };

        "module/bspwm" = {
          type = "internal/bspwm";
          ws-icon-0 ="1;1";
          ws-icon-1 ="2;2";
          ws-icon-2 ="3;3";
          ws-icon-3 ="4;4";
          ws-icon-4 ="5;5";
          ws-icon-5 ="6;6";
          ws-icon-6 ="7;7";
          ws-icon-7 ="8;8";
          ws-icon-8 ="9;9";
          ws-icon-9 ="0;0";
          label-monitor = "%icon%";
          label-focused = "%icon%";
          label-focused-font = 2;
          label-focused-foreground = "\${colors.ac}";
          label-focused-background = "\${colors.bg}";
          label-occupied = "%icon%";
          label-occupied-font = 2;
          label-empty = "%icon%";
          label-empty-font = 2;
          label-empty-foreground = "\${colors.darkgrey}";
          label-empty-background = "\${colors.bg}";
          label-urgent = "%icon%";
          label-urgent-font = 2;
        };

        "module/cpu" = {
          type = "internal/cpu";
          format = "<ramp-coreload>";
          format-foreground = "\${colors.yellow}";
          label = "CPU %percentage%%";
          ramp-coreload-spacing = 1;
          ramp-coreload-0 = "▁";
          ramp-coreload-1 = "▂";
          ramp-coreload-2 = "▃";
          ramp-coreload-3 = "▄";
          ramp-coreload-4 = "▅";
          ramp-coreload-5 = "▆";
          ramp-coreload-6 = "▇";
          ramp-coreload-7 = "█";
        };

        "module/temperature" = {
          type = "internal/temperature";
          warn-temperature = 60;
          format = "<ramp> <label>";
          format-warn = "<ramp> <label-warn>";
          label = "%temperature-c%";
          label-warn = "%temperature-c%";
          label-warn-foreground = "\${colors.red}";


        };

        "module/battery" = {
          type = "internal/battery";
          full-at = 99;
          battery = "BAT0";
          adapter = "ADP1";
          time-format = "%H:%M";
          format-charging = "<animation-charging> <label-charging>";
          format-discharging = "<ramp-capacity> <label-discharging>";
          format-full = "<label-full>";
          format-full-foreground = "\${colors.green}";
          label-charging = "%percentage%%";
          label-discharging = "%percentage%%";
          label-full = "";
          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";
          ramp-capacity-5 = "";
          ramp-capacity-6 = "";
          ramp-capacity-7 = "";
          ramp-capacity-8 = "";
          ramp-capacity-9 = "";
          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-5 = "";
          animation-charging-6 = "";
          animation-charging-framerate = 750;
        };

        "module/volume" = {
          type = "internal/alsa";
          format-volume = "<ramp-volume> <label-volume>";
          format-muted = "<label-muted>";
          label-muted = "婢";
          label-muted-foreground = "\${colors.red}";
          ramp-volume-0 = "奄";
          ramp-volume-1 = "奄";
          ramp-volume-2 = "奔";
          ramp-volume-3 = "奔";
          ramp-volume-4 = "墳";
          ramp-volume-5 = "墳";
          ramp-volume-6 = "墳";
        };

        "module/network" = {
          type = "internal/network";
          interface = "wlp6s0";
          accumulate-stats = true;
          unknown-as-up = true;
          format-connected = "<ramp-signal> <label-connected>";
          format-disconnected = "<label-disconnected>";
          label-connected = "%essid% %local_ip% ﯴ %upspeed% ﯲ %downspeed%";
          label-disconnected = "睊";
          label-disconnected-foreground = "\${colors.red}";
          ramp-signal-0 = "直";
          ramp-signal-1 = "直";
          ramp-signal-2 = "直";
          ramp-signal-3 = "直";
          ramp-signal-4 = "直";
        };
      };
      script = "polybar main &";
    };
    services.dunst = {
      enable =true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "300x5-13+37";
          transparency = 0;
          frame_color = "#fb4934";
          font = "Iosevka Term 20";
          markup = "full";
          plain_text = false;
          format = "<b>%s</b>\\n%b";
          shrink = false;
          sort = false;
          indicate_hidden = true;
          alignment = "center";
          bounce_freq = 0;
          word_wrap = true;
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicates_count = true;
          show_indicators = false;
          line_height = 3;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          separator_color = "frame";
          startup_notification = false;
          icon_position = "left";
          max_icon_size = 80;
        };

        urgency_low = {
          frame_color = "#3B7C87";
          foreground = "#3B7C87";
          background = "#191311";
          timeout = 4;
        };

        urgency_normal = {
          frame_color = "#5B8234";
          foreground = "#5B8234";
          background = "#191311";
          timeout = 6;
        };

        urgency_critical = {
          frame_color = "#B7472A";
          foreground = "#B7472A";
          background = "#191311";
          timeout = 8;
        };
      };
    };
    services.random-background = {
      enable = false;
      imageDirectory = "%h/backgrounds";
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
