{
  programs.fish = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";
    sessionVariables = {
      TERM = "xterm-256color";
    };
    initContent = ''
    zstyle ':completion:*' menu select
    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search

    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'
    '';
  };
  programs.command-not-found  = {
    enable = true;
  };
  programs.fzf = {
    enable = false;
    enableZshIntegration = true;
  };
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
    };
    presets = [ "pure-preset" ];
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "ansi-dark";
    };
  };
  programs.fd = {
    enable = true;
  };
  programs.ripgrep = {
    enable = true;
  };
  programs.yazi = {
    enable = true;

    theme = {
      manager = {
        cwd = { fg = "#83a598"; };

        hovered = { fg = "#282828"; bg = "#83a598"; };
        preview_hovered = { underline = true; };

        find_keyword = { fg = "#b8bb26"; italic = true; };
        find_position = { fg = "#fe8019"; bg = "reset"; italic = true; };

        marker_selected = { fg = "#b8bb26"; bg = "#b8bb26"; };
        marker_copied   = { fg = "#b8bb26"; bg = "#b8bb26"; };
        marker_cut      = { fg = "#fb4934"; bg = "#fb4934"; };

        tab_active   = { fg = "#282828"; bg = "#504945"; };
        tab_inactive = { fg = "#a89984"; bg = "#3c3836"; };
        tab_width = 1;

        border_symbol = "│";
        border_style  = { fg = "#665c54"; };
      };

      status = {
        separator_open  = "";
        separator_close = "";
        separator_style = { fg = "#3c3836"; bg = "#3c3836"; };

        progress_label  = { fg = "#ebdbb2"; bold = true; };
        progress_normal = { fg = "#504945"; bg = "#3c3836"; };
        progress_error  = { fg = "#fb4934"; bg = "#3c3836"; };

        permissions_t = { fg = "#504945"; };
        permissions_r = { fg = "#b8bb26"; };
        permissions_w = { fg = "#fb4934"; };
        permissions_x = { fg = "#b8bb26"; };
        permissions_s = { fg = "#665c54"; };
      };

      mode = {
        normal_main = { fg = "#282828"; bg = "#A89984"; bold = true; };
        normal_alt  = { fg = "#282828"; bg = "#A89984"; bold = true; };

        select_main = { fg = "#282828"; bg = "#b8bb26"; bold = true; };
        select_alt  = { fg = "#282828"; bg = "#b8bb26"; bold = true; };

        unset_main  = { fg = "#282828"; bg = "#d3869b"; bold = true; };
        unset_alt   = { fg = "#282828"; bg = "#d3869b"; bold = true; };
      };

      input = {
        border   = { fg = "#bdae93"; };
        title    = {};
        value    = {};
        selected = { reversed = true; };
      };

      select = {
        border   = { fg = "#504945"; };
        active   = { fg = "#fe8019"; };
        inactive = {};
      };

      tasks = {
        border  = { fg = "#504945"; };
        title   = {};
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = "#3c3836"; };
        cand = { fg = "#83a598"; };
        rest = { fg = "#928374"; };
        desc = { fg = "#fe8019"; };

        separator = "  ";
        separator_style = { fg = "#504945"; };
      };

      help = {
        on      = { fg = "#fe8019"; };
        exec    = { fg = "#83a598"; };
        desc    = { fg = "#928374"; };
        hovered = { bg = "#504945"; bold = true; };
        footer  = { fg = "#3c3836"; bg = "#a89984"; };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = "#83a598"; }

          { mime = "video/*"; fg = "#b8bb26"; }
          { mime = "audio/*"; fg = "#b8bb26"; }

          { mime = "application/zip";             fg = "#fe8019"; }
          { mime = "application/gzip";            fg = "#fe8019"; }
          { mime = "application/x-tar";           fg = "#fe8019"; }
          { mime = "application/x-bzip";          fg = "#fe8019"; }
          { mime = "application/x-bzip2";         fg = "#fe8019"; }
          { mime = "application/x-7z-compressed"; fg = "#fe8019"; }
          { mime = "application/x-rar";           fg = "#fe8019"; }

          { name = "*";  fg = "#a89984"; }
          { name = "*/"; fg = "#83a598"; }
        ];
      };
    };
  };
  programs.htop = {
    enable = true;
  };
  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;
      gui = {
        showRandomTip = false;
      };
    };
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "ghosty.lee.1984@gmail.com";
        name = "Song Li";
      };
      ui = {
        default-command = "log";
      };
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };
  programs.television = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };
}
