{ pkgs, ... }:
{
  # packages {{{
  home.packages = with pkgs; [
    tree
    silver-searcher
    fd
    hexyl
    pamixer
    minicom
    gitAndTools.diff-so-fancy
    unzip
    gitRepo
    file
    ncdu
    nodejs
    clang-tools
    dconf
    gnome3.nautilus
    ctags
    libnotify
    brightnessctl
    vifm
    mupdf
    wget
    feh
    htop
    bat
    neofetch
    ranger
    perl
    nxpmicro-mfgtools
    gnome3.gnome-calendar
    pandoc
    marp
    gcc
    nodePackages.pyright
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    rnix-lsp
    rust-analyzer
    cargo
    rustc
    flameshot
  ];
  # }}}
  # home-manager {{{
    programs.home-manager.enable = true;
  # }}}
  # gpg {{{
    programs.gpg.enable = true;
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
      set termguicolors
      colorscheme gruvbox
      filetype plugin indent on
      syntax enable
      syntax on
      set noswapfile
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
      nnoremap <silent> <Space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
      let mapleader=","
      let maplocalleader=","
      nmap <silent> <leader>v :e ~/.config/nixpkgs/home.nix<CR>
      nmap <silent> <C-h>     :wincmd h<CR>
      nmap <silent> <C-j>     :wincmd j<CR>
      nmap <silent> <C-k>     :wincmd k<CR>
      nmap <silent> <C-l>     :wincmd l<CR>

      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline_theme='gruvbox'

      let g:indentLine_setConceal = 0
      let g:indentLine_concealcursor = ""

      let g:vimwiki_list = [{'path': '~/Nextcloud/Notes/',
                  \ 'auto_tags': 1,
                  \ 'auto_diary_index': 0,
                  \ 'syntax': 'markdown',
                  \ 'ext': '.md'}]
      let g:vimwiki_table_mappings = 0
      let g:vimwiki_key_mappings =
                  \ {
                  \   'all_maps': 1,
                  \   'global': 1,
                  \   'headers': 0,
                  \   'text_objs': 0,
                  \   'table_format': 0,
                  \   'table_mappings': 0,
                  \   'lists': 1,
                  \   'links': 1,
                  \   'html': 0,
                  \   'mouse': 0,
                  \ }
      let g:vimwiki_filetypes = ['markdown', 'pandoc']
      let g:vimwiki_global_ext = 0

      let g:tagbar_width = 30
      nnoremap <leader>t :TagbarToggle<cr>

      nmap <C-t> :GitFiles<CR>

      nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained",
        highlight = {
          enable = true,
          disable = {},
        },
      }
      require'lspconfig'.bashls.setup{}
      require'lspconfig'.clangd.setup{}
      require'lspconfig'.cmake.setup{}
      require'lspconfig'.pyright.setup{}
      require'lspconfig'.rnix.setup{}
      require'lspconfig'.rust_analyzer.setup{}
      require'lspconfig'.yamlls.setup{}

      vim.o.completeopt = "menuone,noselect"
      require'compe'.setup {
        enabled = true;
        autocomplete = true;
        debug = false;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        resolve_timeout = 800;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = false;

        source = {
          path = true;
          buffer = true;
          calc = true;
          nvim_lsp = true;
          nvim_lua = true;
          vsnip = true;
          ultisnips = true;
          luasnip = true;
          spell = true;
          tag = true;
          treesitter = true;
        };
      }
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      -- Use (s-)tab to:
      --- move to prev/next item in completion menuone
      --- jump to prev/next snippet's placeholder
      _G.tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
      elseif vim.fn['vsnip#available'](1) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
      elseif check_back_space() then
        return t "<Tab>"
      else
        return vim.fn['compe#complete']()
        end
      end
      _G.s_tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
      else
        -- If <S-Tab> is not working in your terminal, change it to <C-h>
        return t "<S-Tab>"
        end
      end

      vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
      vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

      require('feline').setup()
      require('gitsigns').setup()

      EOF

      let g:nvim_tree_side = 'left' "left by default
      let g:nvim_tree_width = 40 "30 by default, can be width_in_columns or 'width_in_percent%'
      let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
      let g:nvim_tree_gitignore = 1 "0 by default
      let g:nvim_tree_auto_open = 0 "0 by default, opens the tree when typing `vim $DIR` or `vim`
      let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
      let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
      let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
      let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
      let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
      let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
      let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
      let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
      let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
      let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
      let g:nvim_tree_auto_resize = 0 "1 by default, will resize the tree to its saved width when opening a file
      let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
      let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
      let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
      let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
      let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
      let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
      let g:nvim_tree_hijack_cursor = 0 "1 by default, when moving cursor in the tree, will position the cursor at the start of the file on the current line
      let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
      let g:nvim_tree_update_cwd = 1 "0 by default, will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
      let g:nvim_tree_window_picker_exclude = {
          \   'filetype': [
          \     'packer',
          \     'qf'
          \   ],
          \   'buftype': [
          \     'terminal'
          \   ]
          \ }
      " Dictionary of buffer option names mapped to a list of option values that
      " indicates to the window picker that the buffer's window should not be
      " selectable.
      let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
      let g:nvim_tree_show_icons = {
          \ 'git': 1,
          \ 'folders': 1,
          \ 'files': 1,
          \ 'folder_arrows': 1,
          \ }
      "If 0, do not show the icons for one of 'git' 'folder' and 'files'
      "1 by default, notice that if 'files' is 1, it will only display
      "if nvim-web-devicons is installed and on your runtimepath.
      "if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
      "but this will not work when you set indent_markers (because of UI conflict)

      " default will show icon by default if no icon is provided
      " default shows no icon by default
      let g:nvim_tree_icons = {
          \ 'default': '',
          \ 'symlink': '',
          \ 'git': {
          \   'unstaged': "✗",
          \   'staged': "✓",
          \   'unmerged': "",
          \   'renamed': "➜",
          \   'untracked': "★",
          \   'deleted': "",
          \   'ignored': "◌"
          \   },
          \ 'folder': {
          \   'arrow_open': "",
          \   'arrow_closed': "",
          \   'default': "",
          \   'open': "",
          \   'empty': "",
          \   'empty_open': "",
          \   'symlink': "",
          \   'symlink_open': "",
          \   },
          \   'lsp': {
          \     'hint': "",
          \     'info': "",
          \     'warning': "",
          \     'error': "",
          \   }
          \ }

      nnoremap <leader>e :NvimTreeToggle<CR>
      nnoremap <leader>r :NvimTreeRefresh<CR>
      nnoremap <leader>n :NvimTreeFindFile<CR>
      " NvimTreeOpen and NvimTreeClose are also available if you need them

      " a list of groups can be found at `:help nvim_tree_highlight`
      highlight NvimTreeFolderIcon guibg=blue
    '';
    plugins = with pkgs.vimPlugins; [
      gruvbox
      indentLine
      vim-nix
      vim-fugitive
      nerdcommenter
      vim-signify
      delimitMate
      vim-tmux-navigator
      vimwiki
      tagbar
      fzf-vim
      vim-dirdiff
      vim-pandoc
      vim-pandoc-syntax
      todo-txt-vim
      nvim-treesitter
      nvim-lspconfig
      nvim-compe
      onedark-nvim
      feline-nvim
      nvim-web-devicons
      gitsigns-nvim
      nvim-tree-lua
    ];
  };
  # }}}
  # starship {{{
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
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
      };
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
        '';
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
      signing = {
        signByDefault = true;
        key = "B1E0152BFCF886EC";
      };
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
        pull = {
          ff = "only";
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
        background_opacity = 0.9;
        live_config_reload = true;
      };
    };
  # }}}
  # rofi {{{
    programs.rofi = {
      enable = true;
      theme = "gruvbox-dark";
      font = "hack 10";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
      extraConfig = {
          show-icons = true;
          icon-theme = "Papirus-Dark";
          modi = "drun,run,emoji";
        };
      };
  # }}}
  # firefox {{{
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
  # }}}
  # qutebrowser {{{
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
  # }}}
  # newsboat {{{
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
  # }}}
  # mpv {{{
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
  # }}}
  # password-store {{{
    programs.password-store = {
      enable = true;
    };
  # }}}
  # browserpass {{{
    programs.browserpass = {
      enable = true;
      browsers = ["firefox"];
    };
  # }}}
  # taskwarrior {{{
    programs.taskwarrior = {
      enable = true;
      colorTheme = "dark-blue-256";
    };
  # }}}
  # xsession.windowManager.bspwm {{{
    xsession = {
      enable = true;
      initExtra = " setxkbmap -option caps:ctrl_modifier ";
      pointerCursor = {
        defaultCursor = "left_ptr";
        name = "Vanilla-DMZ";
        size = 16;
        package = pkgs.vanilla-dmz;
      };
      windowManager.bspwm = {
          enable = true;
          monitors = {
            "eDP-1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
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
  # }}}
  # services.sxhkd {{{
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
  # }}}
  # services.polybar {{{
    services.polybar = {
      enable = true;
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
          modules-left = "bspwm cpu";
          modules-center = "date";
          tray-position = "right";
          font-0 = "FiraMono Nerd Font:size=12:weight=bold;3";
          font-1 = "FiraMono Nerd Font Mono:pixelsize=24;6";
          background = "\${colors.bg}";
          foreground = "\${colors.fg}";
          separator = " ";
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
          ws-icon-0 ="1;";
          ws-icon-1 ="2;";
          ws-icon-2 ="3;";
          ws-icon-3 ="4;";
          ws-icon-4 ="5;";
          ws-icon-5 ="6;";
          ws-icon-6 ="7;";
          ws-icon-7 ="8;";
          ws-icon-8 ="9;";
          ws-icon-9 ="0;";
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
          interface = "wlp2s0";
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
  # }}}
  # services.dunst {{{
    services.dunst = {
      enable =true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "300x5-13+37";
          transparency = 0;
          frame_color = "#fb4934";
          font = "Iosevka Term 20";
          markup = "full";
          plain_text = false;
          format = "<b>%s</b>\\n%b";
          shrink = false;
          sort = false;
          indicate_hidden = true;
          alignment = "center";
          bounce_freq = 0;
          word_wrap = true;
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicates_count = true;
          show_indicators = false;
          line_height = 3;
          separator_height = 2;
          padding = 6;
          horizontal_padding = 6;
          separator_color = "frame";
          startup_notification = false;
          icon_position = "left";
          max_icon_size = 80;
        };

        urgency_low = {
          frame_color = "#3B7C87";
          foreground = "#3B7C87";
          background = "#191311";
          timeout = 4;
        };

        urgency_normal = {
          frame_color = "#5B8234";
          foreground = "#5B8234";
          background = "#191311";
          timeout = 6;
        };

        urgency_critical = {
          frame_color = "#B7472A";
          foreground = "#B7472A";
          background = "#191311";
          timeout = 8;
        };
      };
    };
  # }}}
  # services.random-background {{{
    services.random-background = {
      enable = true;
      imageDirectory = "%h/backgrounds";
    };
  # }}}
  # services.syncthing {{{
    services.syncthing = {
      enable = true;
    };
  # }}}
  # services.nextcloud-client {{{
    services.nextcloud-client = {
      enable = true;
    };
  # }}}
  # services.blueman-applet {{{
    services.blueman-applet = {
      enable = true;
    };
  # }}}
  # services.pasystray {{{
    services.pasystray = {
      enable = true;
    };
  # }}}
  # services.cbatticon {{{
    services.cbatticon = {
      enable = true;
    };
  # }}}
  # services.network-manager-applet {{{
    services.network-manager-applet = {
      enable = true;
    };
  # }}}
  # gtk {{{
    gtk = {
      enable = true;
      font = {
        name = "hack 10";
      };
      theme = {
        name = "Sierra-Dark";
        package = pkgs.sierra-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  # }}}
  # systemd {{{
    systemd.user = {
      sessionVariables = {
         GTK_IM_MODULE="fcitx";
         QT_IM_MODULE="fcitx";
         XMODIFIERS="@im=fcitx";
      };
    };
  # }}}
}
