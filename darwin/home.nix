{ pkgs, ... }:
{
  home.stateVersion = "22.05";
  # packages {{{
  home.packages = with pkgs; [
    tree
    silver-searcher
    fd
    ripgrep
    hexyl
    minicom
    gitAndTools.diff-so-fancy
    unzip
    gitRepo
    file
    ncdu
    nodejs
    clang-tools
    dconf
    ctags
    libnotify
    vifm
    wget
    feh
    htop
    bat
    neofetch
    ranger
    perl
    nxpmicro-mfgtools
    pandoc
    gcc
    nodePackages.pyright
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    rnix-lsp
    rust-analyzer
    cargo
    rustc
    fasd
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

      nnoremap <leader>t :SymbolsOutline<cr>

      nmap <C-t> :GitFiles<CR>

      nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          disable = {},
        },
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        }
      }
      require'lspconfig'.bashls.setup{}
      require'lspconfig'.clangd.setup{
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      }
      require'lspconfig'.cmake.setup{}
      require'lspconfig'.pyright.setup{}
      require'lspconfig'.rnix.setup{}
      require'lspconfig'.rust_analyzer.setup{}
      require'lspconfig'.yamlls.setup{}

      require'nvim-tree'.setup {
        disable_netrw       = true,
        hijack_netrw        = true,
        open_on_setup       = false,
        ignore_ft_on_setup  = {},
        update_to_buf_dir   = {
          enable = true,
          auto_open = true,
        },
        open_on_tab         = false,
        hijack_cursor       = false,
        update_cwd          = false,
        update_focused_file = {
          enable      = false,
          update_cwd  = false,
          ignore_list = {}
        },
        system_open = {
          cmd  = nil,
          args = {}
        },
        view = {
          width = 30,
          height = 30,
          side = 'left',
          auto_resize = false,
          mappings = {
            custom_only = false,
            list = {}
          }
        }
      }

      vim.o.completeopt = "menuone,noselect"
      local cmp = require'cmp'

      cmp.setup {
        snippet = {
          expand = function(args)
            -- For `vsnip` user.
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'emoji' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'vsnip' },
          { name = 'orgmode' }
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
        }
      }

      local colors = {
        bg = '#202328',
        fg = '#bbc2cf',
        yellow = '#ECBE7B',
        cyan = '#008080',
        darkblue = '#081633',
        green = '#98be65',
        orange = '#FF8800',
        violet = '#a9a1e1',
        magenta = '#c678dd',
        blue = '#51afef',
        red = '#ec5f67'
      }
      require('lualine').setup {
        options = {
          section_separators = { left = '', right = ''},
          component_separators = { left = '', right = ''}
        },
        extensions = {'quickfix', 'nvim-tree', 'fugitive'},
        sections = {
          lualine_b = {
            'branch',
            'diff'
          },
          lualine_c = {
            'filename',
          },
        }
      }
      require('gitsigns').setup()
      require('hop').setup()
      vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>lua require'hop'.hint_words()<cr>", {})
      require('numb').setup()

      require'colorizer'.setup()

      require("nvim-gps").setup({
        icons = {
          ["class-name"] = ' ',      -- Classes and class-like objects
          ["function-name"] = ' ',   -- Functions
          ["method-name"] = ' ',     -- Methods (functions inside class-like objects)
          ["container-name"] = '⛶ ',  -- Containers (example: lua tables)
          ["tag-name"] = '炙'         -- Tags (example: html tags)
        },
        -- Disable any languages individually over here
        -- Any language not disabled here is enabled by default
        languages = {
          -- ["bash"] = false,
          -- ["go"] = false,
        },
        separator = ' > ',
      })
      EOF

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


      " Find files using Telescope command-line sugar.
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    '';
    plugins = with pkgs.vimPlugins; [
      gruvbox
      indentLine
      vim-nix
      vim-fugitive
      nerdcommenter
      delimitMate
      vim-tmux-navigator
      vimwiki
      fzf-vim
      vim-dirdiff
      vim-pandoc
      vim-pandoc-syntax
      todo-txt-vim
      nvim-treesitter
      nvim-lspconfig
      nvim-cmp
      cmp-path
      cmp-calc
      cmp-buffer
      cmp-emoji
      cmp-spell
      cmp-nvim-lsp
      cmp-vsnip
      vim-vsnip
      friendly-snippets
      lualine-nvim
      lualine-lsp-progress
      nvim-web-devicons
      gitsigns-nvim
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      git-blame-nvim
      hop-nvim
      nvim-ts-rainbow
      numb-nvim
      symbols-outline-nvim
      nvim-colorizer-lua
      nvim-gps
      markdown-preview-nvim
    ];
  };
  # }}}
  # starship {{{
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
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
      enableSyntaxHighlighting = true;
      autocd = true;
      shellAliases = {
        vim = "nvim";
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
        window.opacity = 0.9;
        live_config_reload = true;
      };
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
}
