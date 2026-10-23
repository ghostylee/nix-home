{ inputs, pkgs, config, ...}:
let
  aiUsage = inputs.dankaiusage.packages.${pkgs.stdenv.hostPlatform.system}.release;
  openSessionMenu = pkgs.writeShellScript "noctalia-open-session" ''
    noctalia msg panel-close
    ${pkgs.coreutils}/bin/sleep 0.3
    noctalia msg panel-open session
  '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.dms.homeModules.default
  ];
  home.packages = [
    pkgs.wl-clipboard
    pkgs.xdg-utils
    pkgs.codex
    aiUsage
  ];

  programs.noctalia = {
    enable = false;
    settings = {
      theme.builtin = "Gruvbox";
      bar.main = {
        capsule = true;
        margin_ends = 0;
        start = [ "control-center" "workspaces" "launcher" "weather" ];
        center = [ "clock" ];
        end = [ "tray" "temp" "cpu" "ram" "network_tx" "network_rx" "network" "bluetooth" "volume" "notifications" "session" ];
      };
      # Work around panel-to-panel switching by closing before opening Session.
      widget.session.actions.left = "exec ${openSessionMenu}";
      location.auto_locate = true;
    };
  };

  programs.dank-material-shell = {
    enable = true;
    # Work around khal 0.14.1 failing to produce its man output in nixpkgs.
    enableCalendarEvents = false;
    managePluginSettings = true;
    plugins.dankAIUsage.src = "${aiUsage}/share/dms-plugins/DankAIUsage";
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = "${config.xdg.configHome}/dms/themes/gruvbox.json";
      osdPowerProfileEnabled = true;
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          leftWidgets = [ "launcherButton" "workspaceSwitcher" "focusedWindow" ];
          centerWidgets = [ "music" "clock" "weather" ];
          rightWidgets = [
            "dankAIUsage"
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            { id = "controlCenterButton"; enabled = true; showMicPercent = true; }
          ];
          innerPadding = 4;
        }
      ];
      # Schema version prevents legacy migrations from rewriting this layout.
      configVersion = 42;
      radiusStrength = 38;
      dockConfigs = [
        {
          id = "dock";
          name = "Dock";
          iconSize = 40;
          spacing = 4;
          itemSpacing = 4;
          margin = 0;
          launcherEnabled = false;
          launcherLogoMode = "apps";
        }
      ];
    };
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
  };

  xdg.configFile."dms/themes/gruvbox.json".text = builtins.toJSON {
    id = "gruvbox";
    name = "Gruvbox";
    dark = {
      primary = "#b8bb26";
      primaryText = "#282828";
      primaryContainer = "#3c3836";
      secondary = "#fabd2f";
      surface = "#282828";
      surfaceVariant = "#3c3836";
      surfaceText = "#ebdbb2";
      surfaceVariantText = "#d5c4a1";
      surfaceTint = "#b8bb26";
      background = "#282828";
      backgroundText = "#ebdbb2";
      surfaceContainer = "#32302f";
      surfaceContainerHigh = "#3c3836";
      surfaceContainerHighest = "#504945";
      outline = "#928374";
      error = "#fb4934";
      warning = "#fe8019";
      info = "#83a598";
    };
    light = {
      primary = "#79740e";
      primaryText = "#fbf1c7";
      primaryContainer = "#ebdbb2";
      secondary = "#b57614";
      surface = "#fbf1c7";
      surfaceVariant = "#ebdbb2";
      surfaceText = "#3c3836";
      surfaceVariantText = "#504945";
      surfaceTint = "#79740e";
      background = "#fbf1c7";
      backgroundText = "#3c3836";
      surfaceContainer = "#f2e5bc";
      surfaceContainerHigh = "#ebdbb2";
      surfaceContainerHighest = "#d5c4a1";
      outline = "#928374";
      error = "#9d0006";
      warning = "#af3a03";
      info = "#076678";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    # Keep the session targets active so graphical user services (e.g. Fcitx5) start.
    systemd.extraCommands = [
      "systemctl --user stop hyprland-session.target"
      "systemctl --user start hyprland-session.target"
    ];
    settings = {
      config = {
        input.kb_options = "caps:ctrl_modifier";
        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
        general = {
          gaps_in = 5;
          gaps_out = 10;
        };
        cursor.no_hardware_cursors = 1;
      };

      mod = { _var = "SUPER";};

    };

    extraConfig = ''
        hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
        hl.bind(mod .. " + Space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
        hl.bind(mod .. " + SHIFT + e", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
        hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = "1" }))
        hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = "2" }))
        hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = "3" }))
        hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = "4" }))
        hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = "5" }))
        hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = "6" }))
        hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = "7" }))
        hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = "8" }))
        hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = "9" }))
        hl.bind(mod .. " + 0", hl.dsp.focus({ workspace = "10" }))
        hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
        hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
        hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
        hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
        hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
        hl.bind(mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
        hl.bind(mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
        hl.bind(mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
        hl.bind(mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
        hl.bind(mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
        hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
        hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
        hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
        hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
        hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
        hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
        hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
        hl.bind(mod .. " + w", hl.dsp.window.close())
        hl.bind(mod .. " + m", hl.dsp.window.fullscreen({ mode="maximized", action = "toggle" }))
        hl.bind(mod .. " + SHIFT + s", hl.dsp.exec_cmd("hyprshot -m region"))
        hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
        hl.env("HYPRCURSOR_SIZE", "24")
        hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
        hl.env("XCURSOR_SIZE", "24")
    '';
  };
}
