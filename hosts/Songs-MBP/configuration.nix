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
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-mono
      nerd-fonts.blex-mono
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
    aerospace = {
      enable = true;
      settings = {
        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };
        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
        };
      };
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
    primaryUser = "song";
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
