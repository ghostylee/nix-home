{ config, pkgs, ... }:

let
  yabaiM1 = pkgs.stdenvNoCC.mkDerivation {
    name = "yabai";
    version = "4.0.1";
    src = pkgs.fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v4.0.1/yabai-v4.0.1.tar.gz";
      sha256 = "UFtPBftcBytzvrELOjE4vPCKc3CCaA4bpqusok5sUMU=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -ar ./* $out
      chmod +x $out/bin/yabai
    '';
  };
in {
  nixpkgs.config.allowBroken = true;
  users.users.song = {               # macOS user
    home = "/Users/song";
    shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "Songs-MBP";             # Host name
    hostName = "Songs-MBP";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      nerdfonts
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {                         # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [         # Installed Nix packages
      # Terminal
      alacritty
      git
      ranger
      neovim
    ];
  };

  programs = {                            # Shell needs to be enabled
    zsh.enable = true;
  };

  services = {
    nix-daemon.enable = true;             # Auto upgrade daemon
    yabai = {                             # Tiling window manager
      enable = true;
      package = yabaiM1;
      config = {                          # Other configuration options
        layout = "bsp";
        auto_balance = "on";
        split_ratio = "0.50";
        window_border = "off";
        window_placement = "second_child";
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "on";
        top_padding = "20";
        bottom_padding = "20";
        left_padding = "20";
        right_padding = "20";
        window_gap = "10";
      };
      extraConfig = ''
        yabai -m rule --add title='Preferences' manage=off layer=above
        yabai -m rule --add title='^(Opening)' manage=off layer=above
        yabai -m rule --add title='Library' manage=off layer=above
        yabai -m rule --add app='^System Preferences$' manage=off layer=above
        yabai -m rule --add app='Activity Monitor' manage=off layer=above
        yabai -m rule --add app='Finder' manage=off layer=above
        yabai -m rule --add app='^System Information$' manage=off layer=above
      '';                                 # Specific rules for if it is managed and on which layer
    };
    skhd = {                              # Hotkey daemon
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # Open Terminal
        cmd - return : alacritty
      '';
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    gc = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
    stateVersion = 4;
  };
}
