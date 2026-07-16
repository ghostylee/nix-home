{ inputs, ...}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  programs.noctalia = {
    enable = true;
    settings = {
      theme.builtin = "Gruvbox";
      bar.main = {
        capsule = true;
        margin_ends = 0;
        start = [ "control-center" "workspaces" "launcher" "weather" ];
        center = [ "clock" ];
        end = [ "tray" "temp" "cpu" "ram" "network_tx" "network_rx" "network" "bluetooth" "volume" "notifications" ];
      };
      location.auto_locate = true;
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.extraCommands = [ "noctalia" ];
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
      };

      mod = { _var = "SUPER";};

    };

    extraConfig = ''
        hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
        hl.bind(mod .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
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
