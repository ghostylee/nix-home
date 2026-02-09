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
    obsidian
    img2pdf
    eog
    libva-utils
    tradingview
    remmina
    devenv
    (llm.withPlugins { llm-perplexity = true; llm-gemini = true;})
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
    programs.hyprpanel = {
      enable = true;
      settings = {
        bar.layouts = {
          "*" = {
            left = [ "dashboard" "workspaces" "windowtitle" ];
            middle = [ "clock" ];
            right = [ "cpu" "ram" "storage" "systray" "notifications" ];
          };
        };

        bar.launcher.autoDetectIcon = true;
        bar.workspaces.show_numbered = true;

        menus.clock = {
          time = {
            military = true;
            hideSeconds = true;
          };
          weather.enabled = false;
        };

        menus.dashboard.directories.enabled = true;
        menus.dashboard.stats.enable_gpu = true;

        theme.bar.transparent = true;

        # Gruvbox Theme
        theme.bar.menus.menu.notifications.scrollbar.color= "#83a598";
        theme.bar.menus.menu.notifications.pager.label= "#a89984";
        theme.bar.menus.menu.notifications.pager.button= "#83a598";
        theme.bar.menus.menu.notifications.pager.background= "#1d2021";
        theme.bar.menus.menu.notifications.switch.puck= "#504945";
        theme.bar.menus.menu.notifications.switch.disabled= "#3c3836";
        theme.bar.menus.menu.notifications.switch.enabled= "#83a598";
        theme.bar.menus.menu.notifications.clear= "#83a598";
        theme.bar.menus.menu.notifications.switch_divider= "#504945";
        theme.bar.menus.menu.notifications.border= "#3c3836";
        theme.bar.menus.menu.notifications.card= "#282828";
        theme.bar.menus.menu.notifications.background= "#1d2021";
        theme.bar.menus.menu.notifications.no_notifications_label= "#3c3836";
        theme.bar.menus.menu.notifications.label= "#83a598";
        theme.bar.menus.menu.power.buttons.sleep.icon= "#32302f";
        theme.bar.menus.menu.power.buttons.sleep.text= "#83a598";
        theme.bar.menus.menu.power.buttons.sleep.icon_background= "#83a598";
        theme.bar.menus.menu.power.buttons.sleep.background= "#282828";
        theme.bar.menus.menu.power.buttons.logout.icon= "#32302f";
        theme.bar.menus.menu.power.buttons.logout.text= "#b8bb26";
        theme.bar.menus.menu.power.buttons.logout.icon_background= "#b8bb26";
        theme.bar.menus.menu.power.buttons.logout.background= "#282828";
        theme.bar.menus.menu.power.buttons.restart.icon= "#32302f";
        theme.bar.menus.menu.power.buttons.restart.text= "#fe8019";
        theme.bar.menus.menu.power.buttons.restart.icon_background= "#fe8019";
        theme.bar.menus.menu.power.buttons.restart.background= "#282828";
        theme.bar.menus.menu.power.buttons.shutdown.icon= "#32302f";
        theme.bar.menus.menu.power.buttons.shutdown.text= "#cc241d";
        theme.bar.menus.menu.power.buttons.shutdown.icon_background= "#cc241d";
        theme.bar.menus.menu.power.buttons.shutdown.background= "#282828";
        theme.bar.menus.menu.power.border.color= "#3c3836";
        theme.bar.menus.menu.power.background.color= "#1d2021";
        theme.bar.menus.menu.dashboard.monitors.disk.label= "#d3869b";
        theme.bar.menus.menu.dashboard.monitors.disk.bar= "#d3869b";
        theme.bar.menus.menu.dashboard.monitors.disk.icon= "#d3869b";
        theme.bar.menus.menu.dashboard.monitors.gpu.label= "#b8bb26";
        theme.bar.menus.menu.dashboard.monitors.gpu.bar= "#b8bb26";
        theme.bar.menus.menu.dashboard.monitors.gpu.icon= "#b8bb26";
        theme.bar.menus.menu.dashboard.monitors.ram.label= "#fabd2f";
        theme.bar.menus.menu.dashboard.monitors.ram.bar= "#fabd2f";
        theme.bar.menus.menu.dashboard.monitors.ram.icon= "#fabd2f";
        theme.bar.menus.menu.dashboard.monitors.cpu.label= "#fb4934";
        theme.bar.menus.menu.dashboard.monitors.cpu.bar= "#fb4934";
        theme.bar.menus.menu.dashboard.monitors.cpu.icon= "#fb4934";
        theme.bar.menus.menu.dashboard.monitors.bar_background= "#504945";
        theme.bar.menus.menu.dashboard.directories.right.bottom.color= "#83a598";
        theme.bar.menus.menu.dashboard.directories.right.middle.color= "#b16286";
        theme.bar.menus.menu.dashboard.directories.right.top.color= "#8ec07c";
        theme.bar.menus.menu.dashboard.directories.left.bottom.color= "#fb4934";
        theme.bar.menus.menu.dashboard.directories.left.middle.color= "#fabd2f";
        theme.bar.menus.menu.dashboard.directories.left.top.color= "#d3869b";
        theme.bar.menus.menu.dashboard.controls.input.text= "#32302f";
        theme.bar.menus.menu.dashboard.controls.input.background= "#d3869b";
        theme.bar.menus.menu.dashboard.controls.volume.text= "#32302f";
        theme.bar.menus.menu.dashboard.controls.volume.background= "#fb4934";
        theme.bar.menus.menu.dashboard.controls.notifications.text= "#32302f";
        theme.bar.menus.menu.dashboard.controls.notifications.background= "#fabd2f";
        theme.bar.menus.menu.dashboard.controls.bluetooth.text= "#32302f";
        theme.bar.menus.menu.dashboard.controls.bluetooth.background= "#83a598";
        theme.bar.menus.menu.dashboard.controls.wifi.text= "#32302f";
        theme.bar.menus.menu.dashboard.controls.wifi.background= "#b16286";
        theme.bar.menus.menu.dashboard.controls.disabled= "#665c54";
        theme.bar.menus.menu.dashboard.shortcuts.recording= "#b8bb26";
        theme.bar.menus.menu.dashboard.shortcuts.text= "#32302f";
        theme.bar.menus.menu.dashboard.shortcuts.background= "#83a598";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.button_text= "#1d2021";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.deny= "#d3869b";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.confirm= "#8ec07b";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.body= "#ebdbb2";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.label= "#83a598";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.border= "#3c3836";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.background= "#1d2021";
        theme.bar.menus.menu.dashboard.powermenu.confirmation.card= "#1d2021";
        theme.bar.menus.menu.dashboard.powermenu.sleep= "#83a598";
        theme.bar.menus.menu.dashboard.powermenu.logout= "#b8bb26";
        theme.bar.menus.menu.dashboard.powermenu.restart= "#fe8019";
        theme.bar.menus.menu.dashboard.powermenu.shutdown= "#cc241d";
        theme.bar.menus.menu.dashboard.profile.name= "#d3869b";
        theme.bar.menus.menu.dashboard.border.color= "#3c3836";
        theme.bar.menus.menu.dashboard.background.color= "#1d2021";
        theme.bar.menus.menu.dashboard.card.color= "#282828";
        theme.bar.menus.menu.clock.weather.hourly.temperature= "#d3869b";
        theme.bar.menus.menu.clock.weather.hourly.icon= "#d3869b";
        theme.bar.menus.menu.clock.weather.hourly.time= "#d3869b";
        theme.bar.menus.menu.clock.weather.thermometer.extremelycold= "#83a598";
        theme.bar.menus.menu.clock.weather.thermometer.cold= "#458588";
        theme.bar.menus.menu.clock.weather.thermometer.moderate= "#83a598";
        theme.bar.menus.menu.clock.weather.thermometer.hot= "#fe8019";
        theme.bar.menus.menu.clock.weather.thermometer.extremelyhot= "#cc241d";
        theme.bar.menus.menu.clock.weather.stats= "#d3869b";
        theme.bar.menus.menu.clock.weather.status= "#8ec07c";
        theme.bar.menus.menu.clock.weather.temperature= "#ebdbb2";
        theme.bar.menus.menu.clock.weather.icon= "#d3869b";
        theme.bar.menus.menu.clock.calendar.contextdays= "#665c54";
        theme.bar.menus.menu.clock.calendar.days= "#ebdbb2";
        theme.bar.menus.menu.clock.calendar.currentday= "#d3869b";
        theme.bar.menus.menu.clock.calendar.paginator= "#d3869b";
        theme.bar.menus.menu.clock.calendar.weekdays= "#d3869b";
        theme.bar.menus.menu.clock.calendar.yearmonth= "#8ec07c";
        theme.bar.menus.menu.clock.time.timeperiod= "#8ec07c";
        theme.bar.menus.menu.clock.time.time= "#d3869b";
        theme.bar.menus.menu.clock.text= "#ebdbb2";
        theme.bar.menus.menu.clock.border.color= "#3c3836";
        theme.bar.menus.menu.clock.background.color= "#1d2021";
        theme.bar.menus.menu.clock.card.color= "#282828";
        theme.bar.menus.menu.battery.slider.puck= "#7c6f64";
        theme.bar.menus.menu.battery.slider.backgroundhover= "#504945";
        theme.bar.menus.menu.battery.slider.background= "#665c54";
        theme.bar.menus.menu.battery.slider.primary= "#fabd2f";
        theme.bar.menus.menu.battery.icons.active= "#fabd2f";
        theme.bar.menus.menu.battery.icons.passive= "#a89984";
        theme.bar.menus.menu.battery.listitems.active= "#fabd2f";
        theme.bar.menus.menu.battery.listitems.passive= "#ebdbb2";
        theme.bar.menus.menu.battery.text= "#ebdbb2";
        theme.bar.menus.menu.battery.label.color= "#fabd2f";
        theme.bar.menus.menu.battery.border.color= "#3c3836";
        theme.bar.menus.menu.battery.background.color= "#1d2021";
        theme.bar.menus.menu.battery.card.color= "#282828";
        theme.bar.menus.menu.systray.dropdownmenu.divider= "#1d2021";
        theme.bar.menus.menu.systray.dropdownmenu.text= "#ebdbb2";
        theme.bar.menus.menu.systray.dropdownmenu.background= "#1d2021";
        theme.bar.menus.menu.bluetooth.iconbutton.active= "#83a598";
        theme.bar.menus.menu.bluetooth.iconbutton.passive= "#ebdbb2";
        theme.bar.menus.menu.bluetooth.icons.active= "#83a598";
        theme.bar.menus.menu.bluetooth.icons.passive= "#a89984";
        theme.bar.menus.menu.bluetooth.listitems.active= "#83a598";
        theme.bar.menus.menu.bluetooth.listitems.passive= "#ebdbb2";
        theme.bar.menus.menu.bluetooth.switch.puck= "#504945";
        theme.bar.menus.menu.bluetooth.switch.disabled= "#3c3836";
        theme.bar.menus.menu.bluetooth.switch.enabled= "#83a598";
        theme.bar.menus.menu.bluetooth.switch_divider= "#504945";
        theme.bar.menus.menu.bluetooth.status= "#7c6f64";
        theme.bar.menus.menu.bluetooth.text= "#ebdbb2";
        theme.bar.menus.menu.bluetooth.label.color= "#83a598";
        theme.bar.menus.menu.bluetooth.border.color= "#3c3836";
        theme.bar.menus.menu.bluetooth.background.color= "#1d2021";
        theme.bar.menus.menu.bluetooth.card.color= "#282828";
        theme.bar.menus.menu.network.iconbuttons.active= "#b16286";
        theme.bar.menus.menu.network.iconbuttons.passive= "#ebdbb2";
        theme.bar.menus.menu.network.icons.active= "#b16286";
        theme.bar.menus.menu.network.icons.passive= "#a89984";
        theme.bar.menus.menu.network.listitems.active= "#b16286";
        theme.bar.menus.menu.network.listitems.passive= "#ebdbb2";
        theme.bar.menus.menu.network.status.color= "#7c6f64";
        theme.bar.menus.menu.network.text= "#ebdbb2";
        theme.bar.menus.menu.network.label.color= "#b16286";
        theme.bar.menus.menu.network.border.color= "#3c3836";
        theme.bar.menus.menu.network.background.color= "#1d2021";
        theme.bar.menus.menu.network.card.color= "#282828";
        theme.bar.menus.menu.volume.input_slider.puck= "#665c54";
        theme.bar.menus.menu.volume.input_slider.backgroundhover= "#504945";
        theme.bar.menus.menu.volume.input_slider.background= "#665c54";
        theme.bar.menus.menu.volume.input_slider.primary= "#fe8018";
        theme.bar.menus.menu.volume.audio_slider.puck= "#665c54";
        theme.bar.menus.menu.volume.audio_slider.backgroundhover= "#504945";
        theme.bar.menus.menu.volume.audio_slider.background= "#665c54";
        theme.bar.menus.menu.volume.audio_slider.primary= "#fe8018";
        theme.bar.menus.menu.volume.icons.active= "#fe8018";
        theme.bar.menus.menu.volume.icons.passive= "#a89984";
        theme.bar.menus.menu.volume.iconbutton.active= "#fe8018";
        theme.bar.menus.menu.volume.iconbutton.passive= "#ebdbb2";
        theme.bar.menus.menu.volume.listitems.active= "#fe8018";
        theme.bar.menus.menu.volume.listitems.passive= "#ebdbb2";
        theme.bar.menus.menu.volume.text= "#ebdbb2";
        theme.bar.menus.menu.volume.label.color= "#fe8018";
        theme.bar.menus.menu.volume.border.color= "#3c3836";
        theme.bar.menus.menu.volume.background.color= "#1d2021";
        theme.bar.menus.menu.volume.card.color= "#282828";
        theme.bar.menus.menu.media.slider.puck= "#7c6f64";
        theme.bar.menus.menu.media.slider.backgroundhover= "#504945";
        theme.bar.menus.menu.media.slider.background= "#665c54";
        theme.bar.menus.menu.media.slider.primary= "#d3869b";
        theme.bar.menus.menu.media.buttons.text= "#1d2021";
        theme.bar.menus.menu.media.buttons.background= "#83a598";
        theme.bar.menus.menu.media.buttons.enabled= "#8ec07c";
        theme.bar.menus.menu.media.buttons.inactive= "#665c54";
        theme.bar.menus.menu.media.border.color= "#3c3836";
        theme.bar.menus.menu.media.card.color= "#282828";
        theme.bar.menus.menu.media.background.color= "#1d2021";
        theme.bar.menus.menu.media.album= "#d3869b";
        theme.bar.menus.menu.media.artist= "#8ec07c";
        theme.bar.menus.menu.media.song= "#83a598";
        theme.bar.menus.tooltip.text= "#ebdbb2";
        theme.bar.menus.tooltip.background= "#1d2021";
        theme.bar.menus.dropdownmenu.divider= "#1d2021";
        theme.bar.menus.dropdownmenu.text= "#ebdbb2";
        theme.bar.menus.dropdownmenu.background= "#1d2021";
        theme.bar.menus.slider.puck= "#7c6f64";
        theme.bar.menus.slider.backgroundhover= "#504945";
        theme.bar.menus.slider.background= "#665c54";
        theme.bar.menus.slider.primary= "#83a598";
        theme.bar.menus.progressbar.background= "#504945";
        theme.bar.menus.progressbar.foreground= "#83a598";
        theme.bar.menus.iconbuttons.active= "#83a598";
        theme.bar.menus.iconbuttons.passive= "#ebdbb2";
        theme.bar.menus.buttons.text= "#32302f";
        theme.bar.menus.buttons.disabled= "#665c54";
        theme.bar.menus.buttons.active= "#d3869b";
        theme.bar.menus.buttons.default= "#83a598";
        theme.bar.menus.check_radio_button.active= "#83a598";
        theme.bar.menus.check_radio_button.background= "#3c3836";
        theme.bar.menus.switch.puck= "#504945";
        theme.bar.menus.switch.disabled= "#3c3836";
        theme.bar.menus.switch.enabled= "#83a598";
        theme.bar.menus.icons.active= "#83a598";
        theme.bar.menus.icons.passive= "#665c54";
        theme.bar.menus.listitems.active= "#83a598";
        theme.bar.menus.listitems.passive= "#ebdbb2";
        theme.bar.menus.popover.border= "#32302f";
        theme.bar.menus.popover.background= "#32302f";
        theme.bar.menus.popover.text= "#83a598";
        theme.bar.menus.label= "#83a598";
        theme.bar.menus.feinttext= "#3c3836";
        theme.bar.menus.dimtext= "#665c54";
        theme.bar.menus.text= "#ebdbb2";
        theme.bar.menus.border.color= "#3c3836";
        theme.bar.menus.cards= "#1d2021";
        theme.bar.menus.background= "#1d2021";
        theme.bar.buttons.modules.power.icon_background= "#282828";
        theme.bar.buttons.modules.power.icon= "#cc241d";
        theme.bar.buttons.modules.power.background= "#282828";
        theme.bar.buttons.modules.weather.icon_background= "#282828";
        theme.bar.buttons.modules.weather.icon= "#fe8017";
        theme.bar.buttons.modules.weather.text= "#fe8017";
        theme.bar.buttons.modules.weather.background= "#282828";
        theme.bar.buttons.modules.updates.icon_background= "#282828";
        theme.bar.buttons.modules.updates.icon= "#b16286";
        theme.bar.buttons.modules.updates.text= "#b16286";
        theme.bar.buttons.modules.updates.background= "#282828";
        theme.bar.buttons.modules.kbLayout.icon_background= "#282828";
        theme.bar.buttons.modules.kbLayout.icon= "#83a598";
        theme.bar.buttons.modules.kbLayout.text= "#83a598";
        theme.bar.buttons.modules.kbLayout.background= "#282828";
        theme.bar.buttons.modules.netstat.icon_background= "#282828";
        theme.bar.buttons.modules.netstat.icon= "#b8bb26";
        theme.bar.buttons.modules.netstat.text= "#b8bb26";
        theme.bar.buttons.modules.netstat.background= "#282828";
        theme.bar.buttons.modules.storage.icon_background= "#282828";
        theme.bar.buttons.modules.storage.icon= "#83a598";
        theme.bar.buttons.modules.storage.text= "#83a598";
        theme.bar.buttons.modules.storage.background= "#282828";
        theme.bar.buttons.modules.cpu.icon_background= "#282828";
        theme.bar.buttons.modules.cpu.icon= "#d3869b";
        theme.bar.buttons.modules.cpu.text= "#d3869b";
        theme.bar.buttons.modules.cpu.background= "#282828";
        theme.bar.buttons.modules.ram.icon_background= "#282828";
        theme.bar.buttons.modules.ram.icon= "#fabd2f";
        theme.bar.buttons.modules.ram.text= "#fabd2f";
        theme.bar.buttons.modules.ram.background= "#282828";
        theme.bar.buttons.notifications.total= "#83a598";
        theme.bar.buttons.notifications.icon_background= "#83a598";
        theme.bar.buttons.notifications.icon= "#83a598";
        theme.bar.buttons.notifications.background= "#282828";
        theme.bar.buttons.clock.icon_background= "#d3869b";
        theme.bar.buttons.clock.icon= "#d3869b";
        theme.bar.buttons.clock.text= "#d3869b";
        theme.bar.buttons.clock.background= "#282828";
        theme.bar.buttons.battery.icon_background= "#fabd2f";
        theme.bar.buttons.battery.icon= "#fabd2f";
        theme.bar.buttons.battery.text= "#fabd2f";
        theme.bar.buttons.battery.background= "#282828";
        theme.bar.buttons.systray.background= "#282828";
        theme.bar.buttons.bluetooth.icon_background= "#83a598";
        theme.bar.buttons.bluetooth.icon= "#83a598";
        theme.bar.buttons.bluetooth.text= "#83a598";
        theme.bar.buttons.bluetooth.background= "#282828";
        theme.bar.buttons.network.icon_background= "#b16286";
        theme.bar.buttons.network.icon= "#b16286";
        theme.bar.buttons.network.text= "#b16286";
        theme.bar.buttons.network.background= "#282828";
        theme.bar.buttons.volume.icon_background= "#fe8018";
        theme.bar.buttons.volume.icon= "#fe8018";
        theme.bar.buttons.volume.text= "#fe8018";
        theme.bar.buttons.volume.background= "#282828";
        theme.bar.buttons.media.icon_background= "#83a598";
        theme.bar.buttons.media.icon= "#83a598";
        theme.bar.buttons.media.text= "#83a598";
        theme.bar.buttons.media.background= "#282828";
        theme.bar.buttons.windowtitle.icon_background= "#d3869b";
        theme.bar.buttons.windowtitle.icon= "#d3869b";
        theme.bar.buttons.windowtitle.text= "#d3869b";
        theme.bar.buttons.windowtitle.background= "#282828";
        theme.bar.buttons.workspaces.numbered_active_underline_color= "#ffffff";
        theme.bar.buttons.workspaces.numbered_active_highlighted_text_color= "#21252b";
        theme.bar.buttons.workspaces.active= "#d3869b";
        theme.bar.buttons.workspaces.occupied= "#fb4934";
        theme.bar.buttons.workspaces.available= "#83a598";
        theme.bar.buttons.workspaces.hover= "#504945";
        theme.bar.buttons.workspaces.background= "#282828";
        theme.bar.buttons.dashboard.icon= "#fabd2f";
        theme.bar.buttons.dashboard.background= "#282828";
        theme.bar.buttons.icon= "#83a598";
        theme.bar.buttons.text= "#83a598";
        theme.bar.buttons.hover= "#504945";
        theme.bar.buttons.icon_background= "#242438";
        theme.bar.buttons.background= "#282828";
        theme.bar.buttons.style= "default";
        theme.bar.background= "#1d2021";
        theme.osd.label= "#83a598";
        theme.osd.icon= "#1d2021";
        theme.osd.bar_overflow_color= "#cc241d";
        theme.osd.bar_empty_color= "#3c3836";
        theme.osd.bar_color= "#83a598";
        theme.osd.icon_container= "#83a598";
        theme.osd.bar_container= "#1d2021";
        theme.notification.close_button.label= "#1d2021";
        theme.notification.close_button.background= "#83a598";
        theme.notification.labelicon= "#83a598";
        theme.notification.text= "#ebdbb2";
        theme.notification.time= "#928374";
        theme.notification.border= "#3c3836";
        theme.notification.label= "#83a598";
        theme.notification.actions.text= "#32302f";
        theme.notification.actions.background= "#83a598";
        theme.notification.background= "#32302f";
        theme.bar.buttons.modules.power.border= "#282828";
        theme.bar.buttons.modules.weather.border= "#fe8017";
        theme.bar.buttons.modules.updates.border= "#b16286";
        theme.bar.buttons.modules.kbLayout.border= "#83a598";
        theme.bar.buttons.modules.netstat.border= "#b8bb26";
        theme.bar.buttons.modules.storage.border= "#83a598";
        theme.bar.buttons.modules.cpu.border= "#d3869b";
        theme.bar.buttons.modules.ram.border= "#fabd2f";
        theme.bar.buttons.notifications.border= "#83a598";
        theme.bar.buttons.clock.border= "#d3869b";
        theme.bar.buttons.battery.border= "#fabd2f";
        theme.bar.buttons.systray.border= "#504945";
        theme.bar.buttons.bluetooth.border= "#83a598";
        theme.bar.buttons.network.border= "#b16286";
        theme.bar.buttons.volume.border= "#fe8018";
        theme.bar.buttons.media.border= "#83a598";
        theme.bar.buttons.windowtitle.border= "#d3869b";
        theme.bar.buttons.workspaces.border= "#ffffff";
        theme.bar.buttons.dashboard.border= "#fabd2f";
        theme.bar.buttons.modules.submap.background= "#282828";
        theme.bar.buttons.modules.submap.text= "#8ec07c";
        theme.bar.buttons.modules.submap.border= "#8ec07c";
        theme.bar.buttons.modules.submap.icon= "#8ec07c";
        theme.bar.buttons.modules.submap.icon_background= "#282828";
        theme.bar.menus.menu.network.switch.enabled= "#b16286";
        theme.bar.menus.menu.network.switch.disabled= "#3c3836";
        theme.bar.menus.menu.network.switch.puck= "#504945";
        theme.bar.buttons.systray.customIcon= "#ebdbb2";
        theme.bar.border.color= "#83a598";
        theme.bar.menus.menu.media.timestamp= "#ebdbb2";
        theme.bar.buttons.borderColor= "#83a598";
        theme.bar.buttons.modules.hyprsunset.icon= "#fabd2f";
        theme.bar.buttons.modules.hyprsunset.background= "#282828";
        theme.bar.buttons.modules.hyprsunset.icon_background= "#282828";
        theme.bar.buttons.modules.hyprsunset.text= "#fabd2f";
        theme.bar.buttons.modules.hyprsunset.border= "#fabd2f";
        theme.bar.buttons.modules.hypridle.icon= "#83a598";
        theme.bar.buttons.modules.hypridle.background= "#282828";
        theme.bar.buttons.modules.hypridle.icon_background= "#282828";
        theme.bar.buttons.modules.hypridle.text= "#83a598";
        theme.bar.buttons.modules.hypridle.border= "#83a598";
        theme.bar.menus.menu.network.scroller.color= "#b16286";
        theme.bar.menus.menu.bluetooth.scroller.color= "#83a598";
        theme.bar.buttons.modules.cava.text= "#8ec07c";
        theme.bar.buttons.modules.cava.background= "#282828";
        theme.bar.buttons.modules.cava.icon_background= "#282828";
        theme.bar.buttons.modules.cava.icon= "#8ec07c";
        theme.bar.buttons.modules.cava.border= "#8ec07c";
        theme.bar.buttons.modules.microphone.border= "#b8bb26";
        theme.bar.buttons.modules.microphone.background= "#282828";
        theme.bar.buttons.modules.microphone.text= "#b8bb26";
        theme.bar.buttons.modules.microphone.icon= "#b8bb26";
        theme.bar.buttons.modules.microphone.icon_background= "#282828";
        theme.bar.buttons.modules.worldclock.text= "#d3869b";
        theme.bar.buttons.modules.worldclock.background= "#282828";
        theme.bar.buttons.modules.worldclock.icon_background= "#d3869b";
        theme.bar.buttons.modules.worldclock.icon= "#d3869b";
        theme.bar.buttons.modules.worldclock.border= "#d3869b";


        theme.font = {
          name = "CommitMono Nerd Font";
          size = "16px";
        };
      };
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
