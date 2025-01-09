{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig =
    ''
      set t_Co=256
      set background=dark
      set termguicolors
      colorscheme monokai-pro-octagon
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

      let g:vimwiki_list = [{'path': '~/Notes/',
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
      let g:vimwiki_filetypes = ['markdown']
      let g:vimwiki_global_ext = 0
      let g:vimwiki_folding = 'custom'


      nmap <C-t> :GitFiles<CR>

      nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>

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

      nnoremap <leader>x <cmd>Trouble diagnostics toggle<cr>
      nnoremap <leader>t <cmd>Trouble symbols toggle<cr>
    '';
    extraLuaConfig = ''
      -- Defines a read-write directory for treesitters in nvim's cache dir
      local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
      vim.fn.mkdir(parser_install_dir, "p")
      require'nvim-treesitter.configs'.setup {
        parser_install_dir = parser_install_dir,
        ensure_installed = "",
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
      require'lspconfig'.clangd.setup{}
      require'lspconfig'.cmake.setup{}
      require'lspconfig'.pyright.setup{}
      require'lspconfig'.nixd.setup{}
      require'lspconfig'.rust_analyzer.setup{}
      require'lspconfig'.yamlls.setup{}

      require'nvim-tree'.setup {
        disable_netrw       = true,
        hijack_netrw        = true,
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
          side = 'left',
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
          { name = 'orgmode' },
          { name = 'spell' },
          { name = 'render-markdown' },
          { name = 'nvim_lsp_document_symbol' }
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
        extensions = {'quickfix', 'nvim-tree', 'fugitive', 'trouble'},
        sections = {
          lualine_b = { 'branch', 'diff', },
          lualine_c = { 'filename' },
        }
      }
      require('gitsigns').setup()
      require('hop').setup()
      vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>lua require'hop'.hint_words()<cr>", {})
      require('numb').setup()

      require'colorizer'.setup()

      require("symbols-outline").setup()

      require('render-markdown').setup({
        file_types = {'markdown', 'vimwiki'},
      })
      vim.treesitter.language.register('markdown', 'vimwiki')
      require('trouble').setup()
      require('lsp_signature').setup()
      require('lsp_lines').setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';
    plugins = with pkgs.vimPlugins; [
      monokai-pro-nvim
      indentLine
      vim-nix
      vim-fugitive
      nerdcommenter
      delimitMate
      vim-tmux-navigator
      vimwiki
      fzf-vim
      vim-dirdiff
      todo-txt-vim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      nvim-cmp
      cmp-path
      cmp-calc
      cmp-buffer
      cmp-emoji
      cmp-spell
      cmp-nvim-lsp
      cmp-vsnip
      cmp-nvim-lsp-document-symbol
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
      numb-nvim
      symbols-outline-nvim
      nvim-colorizer-lua
      markdown-preview-nvim
      render-markdown-nvim
      trouble-nvim
      lsp_lines-nvim
      lsp_signature-nvim
    ];
    extraPackages = with pkgs; [
      nixd
      tree-sitter
      clang-tools
      ctags
      pandoc
      pyright
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      cmake-language-server
      rust-analyzer
      cargo
      rustc
      wl-clipboard
      ripgrep
      fd
    ];
  };
}
