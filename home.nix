{ pkgs, ... }:
let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in
{
  # packages {{{
  home.packages = with pkgs; [
    tree
    silver-searcher
    hexyl
    fd
    pamixer
    minicom
    gitAndTools.diff-so-fancy
    unzip
    gitRepo
    file
    ncdu
    nodejs
    clang-tools
    rls
  ];
  # }}}
  # home-manager {{{
    programs.home-manager.enable = true;
  # }}}
  # command-not-found {{{
    programs.command-not-found.enable = true;
  # }}}
  # fzf {{{
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  # }}}
  # lsd {{{
    programs.lsd = {
      enable = true;
      enableAliases = true;
    };
  # }}}
  # tmux {{{
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      terminal = "xterm-256color";
      customPaneNavigationAndResize = true;
      plugins = with pkgs.tmuxPlugins; [
        gruvbox
      ];
    };
  # }}}
  # neovim {{{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig =
    ''
      set t_Co=256
      set background=dark
      colorscheme gruvbox
      filetype plugin indent on
      syntax enable
      syntax on
      set autoread
      set autochdir
      set wildmenu
      set hidden
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
      set clipboard=unnamedplus
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

      let g:coc_global_extensions = [ 'coc-clangd', 'coc-cmake', 'coc-rls', 'coc-highlight', 'coc-json', 'coc-lists' ]

      inoremap <silent><expr> <TAB>  pumvisible() ? "\<C-n>" :  <SID>check_back_space() ? "<TAB>" :  coc#refresh()
      inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      if exists('*complete_info')
        inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
      else
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
      endif

      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)

      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      nnoremap <silent> K :call <SID>show_documentation()<CR>

      function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
        else
          call CocAction('doHover')
        endif
      endfunction
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
      coc-nvim
    ];
  };
  # }}}
  # zsh {{{
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      autocd = true;
      shellAliases = {
        vimdiff = "nvim -d";
      };
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
          "context"
          "os_icon"
          "nix_shell"
          "dir"
          "vcs"
          "newline"
        ];
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [
          "ip"
          "time"
          "newline"
          "status"
          "command_execution_time"
          "battery"
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
        POWERLEVEL9K_IP_INTERFACE="wlp2s0";
        POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION="";
        POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE="";
        POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=0;
        POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=1;
      };
      profileExtra =
        ''
        source ~/.nix-profile/etc/profile.d/nix.sh
        '';
        initExtraBeforeCompInit =
          ''
          source /etc/profile
          '';
          initExtra =
            ''
            zstyle ':completion:*' menu select
            autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
            zle -N up-line-or-beginning-search
            zle -N down-line-or-beginning-search
            bindkey "^[[A" up-line-or-beginning-search
            bindkey "^[[B" down-line-or-beginning-search

            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'

            POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20;
            POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1;
            POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=2;
            POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND=2;
            POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=3;
            POWERLEVEL9K_BATTERY_VERBOSE=false;
            POWERLEVEL9K_BATTERY_STAGES=('%K{232}▁' '%K{232}▂' '%K{232}▃' '%K{232}▄' '%K{232}▅' '%K{232}▆' '%K{232}▇' '%K{232}█')
            POWERLEVEL9K_BATTERY_BACKGROUND=0;
            '';
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
  # }}}
  # direnv {{{
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };
  # }}}
  # bat {{{
    programs.bat = {
      enable = true;
      config = {
        theme = "ansi-dark";
      };
    };
  # }}}
  # git {{{
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
      extraConfig = {
        core = {
          pager = "diff-so-fancy | less --tabs=4 -RFX";
        };
      };
    };
  # }}}
  # alacritty {{{
    programs.alacritty = {
      enable = true;
      settings = {
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          normal = {
            family = "Hack Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "Hack Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "Hack Nerd Font Mono";
            style = "Italic";
          };
          size = 10;
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
  # }}}
  # rofi {{{
    programs.rofi = {
      enable = true;
    };
  # }}}
  # firefox {{{
    programs.firefox = {
      enable = true;
      extensions = with nur.repos.rycee.firefox-addons; [
        darkreader
        vimium
        ublock-origin
      ];
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
  # }}}
  # qutebrowser {{{
    programs.qutebrowser = {
      enable = true;
    };
  # }}}
  # xsession.windowManager.bspwm {{{
    xsession = {
      enable = true;
      initExtra =
        ''
        setxkbmap -option caps:ctrl_modifier
        xsetroot -cursor_name left_ptr
        '';
        windowManager.bspwm = {
          enable = true;
          monitors = {
            "" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
          };
          settings = {
            border_width = 2;
            window_gap = 12;
            split_ratio = 0.52;
            borderless_monocle = true;
            gapless_monocle = true;
          };
        };
      };
  # }}}
  # services.sxhkd {{{
    services.sxhkd = {
      enable = true;
      keybindings = {
        "super + Return" = "alacritty";
        "super + @space" = "rofi -show run";
        "XF86AudioMute" = "pamixer -t";
        "XF86Audio{Raise,Lower}Volume" = "pamixer -{i,d} 5";
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
  # }}}
  # services.polybar {{{
    services.polybar = {
      enable = true;
      config = {
        "bar/main" = {
          width = "100%";
          height = "3%";
          radius = 0;
          modules-left = "bspwm";
          modules-center = "date";
          tray-position = "right";
        };

        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%d.%m.%y";
          time = "%H:%M";
          label = "%time%  %date%";
        };

        "module/bspwm" = {
          type = "internal/bspwm";
          label-focused-foreground = "#ffffff";
          label-focused-background = "#3f3f3f";
          label-focused-underline = "#fba922";

        };
      };
      script = "polybar main &";
    };
  # }}}
  # services.pasystray {{{
    services.pasystray.enable = true;
  # }}}
}
