{ pkgs, ... }:
{
 programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
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
      set foldmethod=expr
      set foldexpr=v:lua.vim.treesitter.foldexpr()
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
    '';
    extraLuaConfig = ''
      -- Defines a read-write directory for treesitters in nvim's cache dir
      local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
      vim.fn.mkdir(parser_install_dir, "p")
      require'nvim-treesitter'.setup {
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
      vim.lsp.enable('bashls')
      vim.lsp.enable('clangd')
      vim.lsp.enable('cmake')
      vim.lsp.enable('pyright')
      vim.lsp.enable('nixd')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('yamlls')

      require('blink.cmp').setup({
        keymap = {
          preset = 'default',
          ['<CR>'] = { 'accept', 'fallback' },
          ['<Tab>'] = { 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        },
        completion = { list = { selection = { preselect = false, auto_insert = true } } },
        appearance = {
          nerd_font_variant = 'mono'
        },
        completion = { documentation = { auto_show = false } },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
      })

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

      require('render-markdown').setup()
      require('trouble').setup()
      require('lsp_signature').setup()
      require('tiny-inline-diagnostic').setup()
      require('snacks').setup({
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      })
      require('obsidian').setup({
        legacy_commands = false,
        workspaces = {
          {
            name = "nextcloud-notes",
            path = "~/Notes",
          },
        },
        templates = {
          folder = "Templates",
        },
      })

      keymaps = {
        -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- gh
        { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
        { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
        { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
        { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
        { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        -- Other
        { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
        { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      }
      for _, map in ipairs(keymaps) do
        local opts = { desc = map.desc }
        if map.silent ~= nil then
          opts.silent = map.silent
        end
        if map.noremap ~= nil then
          opts.noremap = map.noremap
        else
          opts.noremap = true
        end
        if map.expr ~= nil then
          opts.expr = map.expr
        end

        local mode = map.mode or "n"
        vim.keymap.set(mode, map[1], map[2], opts)
      end
    '';
    plugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      indentLine
      vim-nix
      vim-fugitive
      nerdcommenter
      delimitMate
      vim-tmux-navigator
      snacks-nvim
      vim-dirdiff
      todo-txt-vim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      blink-cmp
      vim-vsnip
      friendly-snippets
      lualine-nvim
      lualine-lsp-progress
      nvim-web-devicons
      gitsigns-nvim
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      hop-nvim
      numb-nvim
      nvim-colorizer-lua
      markdown-preview-nvim
      render-markdown-nvim
      trouble-nvim
      tiny-inline-diagnostic-nvim
      lsp_signature-nvim
      obsidian-nvim
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
      ripgrep
      fd
      ninja
      bear
      cmake
    ];
  };
}
