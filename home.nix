{ pkgs, ... }:

{
  home.packages = with pkgs; [
    tree
    silver-searcher
    hexyl
    fd
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "xterm-256color";
    customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      vim-tmux-navigator
    ];
  };

  programs.vim = {
    enable = true;
    extraConfig =
    ''
      set t_Co=256
      set background=dark
      colorscheme gruvbox
      set shortmess=atI
      set nocompatible
      set nobackup
      set encoding=utf-8
      set number
      set nowrap
      set tabstop=4
      set backspace=2
      set shiftwidth=4
      set softtabstop=4
      set smarttab
      set expandtab
      set ignorecase
      set smartcase
      set infercase
      set hlsearch
      set showmatch
      set list
      set listchars=tab:▸\ ,trail:¬
      set foldenable
      set foldmethod=marker
      set foldlevel=0
      set foldlevelstart=0
      set keywordprg=":help"
      nnoremap <Space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
      let mapleader=","
      let maplocalleader=","
      nmap <silent> <leader>v :e ~/.config/nixpkgs/home.nix<CR>
      nmap <silent> <leader>e :NERDTreeToggle<CR>
      nmap <silent> <C-h>     :wincmd h<CR>
      nmap <silent> <C-j>     :wincmd j<CR>
      nmap <silent> <C-k>     :wincmd k<CR>
      nmap <silent> <C-l>     :wincmd l<CR>

      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline_theme='gruvbox'

      let g:indentLine_setConceal = 0
      let g:indentLine_concealcursor = ""
    '';
    plugins = with pkgs.vimPlugins; [
      gruvbox
      nerdtree
      vim-airline
      vim-airline-themes
      indentLine
      vim-nix
      vim-fugitive
      nerdcommenter
      vim-signify
      delimitMate
      vim-devicons
      vim-tmux-navigator
    ];
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
    sessionVariables = {
      TERM = "xterm-256color";
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
    };
    localVariables = {
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [
        "os_icon"
        "dir"
        "vcs"
        "newline"
      ];
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [
        "status"
        "command_execution_time"
        "nix_shell"
        "newline"
      ];
      POWERLEVEL9K_MODE="nerdfont-complete";
      POWERLEVEL9K_ICON_PADDING="none";
      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%242F╭─";
      POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX="%242F├─";
      POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%242F╰─";
      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX="%242F─╮";
      POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX="%242F─┤";
      POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX="%242F─╯";
      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR="·";
      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND="";
      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242;
      POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL="%{%}";
      POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL="%{%}";
      POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="\\u2502";
      POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="\\u2502";
      POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="";
      POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="";
      POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL="\\uE0B0";
      POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL="\\uE0B2";
      POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL="";
      POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL="";
      POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL="";
      POWERLEVEL9K_OS_ICON_FOREGROUND=232;
      POWERLEVEL9K_OS_ICON_BACKGROUND=7;
      POWERLEVEL9K_DIR_FRONTGROUND=237;
      POWERLEVEL9K_DIR_BACKGROUND=214;
      POWERLEVEL9K_VCS_CLEAN_BACKGROUND=10;
      POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=9;
      POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=10;
      POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=9;
      POWERLEVEL9K_VCS_LOADING_BACKGROUND=8;
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
