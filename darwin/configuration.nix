{ config, pkgs, ... }:

{
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "nix-2.16.2" ];
  users.users.song = {               # macOS user
    home = "/Users/song";
    shell = pkgs.zsh;                     # Default shell
  };


  networking = {
    computerName = "Songs-MBP";             # Host name
    hostName = "Songs-MBP";
  };

  fonts = {                               # Fonts
    packages = with pkgs; [
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
        cmd - return : ~/Applications/Home\ Manager\ Apps/Alacritty.app/Contents/MacOS/alacritty
      '';
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      auto-optimise-store = false
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
