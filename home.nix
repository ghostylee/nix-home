{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
    silver-searcher
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };
  
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";
    dotDir = ".config/zsh";
    history = {
      path = ".zsh_history";
      size = 10000;
    };
    profileExtra = ". $HOME/.nix-profile/etc/profile.d/nix.sh";
    plugins = [
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.5.0";
          sha256 = "0r8vccgfy85ryswaigzgwmvhvrhlap7nrg7bi66w63877znqlksj";
        };
      }
    ];
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi-dark";
    };
  };
  programs.git = {
    enable = true;
    userName = "Song Li";
    userEmail = "ghosty.lee.1984@gmail.com";
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
  };

  programs.alacritty = {
    enable = true;
    settings = {
      scrolling = {
        history = 10000;
        multiplier = 3;
        auto_scroll = false;
      };
      tabspaces = 4;
      font = {
        normal = {
          family = "RobotoMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "RobotoMono Nerd Font";
          style = "Regular";
        };
        italic = {
          family = "RobotoMono Nerd Font";
          style = "Regular";
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
      live_config_reload = true;
    };
  };
}
