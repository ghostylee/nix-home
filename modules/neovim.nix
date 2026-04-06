{ pkgs, ... }:
let
  markdown-plus-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "markdown-plus.nvim";
    version = "v1.10.0";
    src = pkgs.fetchFromGitHub {
      owner = "YousefHadder";
      repo = "markdown-plus.nvim";
      rev = "9ae1b048f939731ea1c5c04a9e1c7ee97205236c";
      hash = "sha256-f4COT377GsQo0QUdzbv9D5V0auYrGSW8LtSdviGipXQ=";
    };
    meta.homepage = "https://github.com/YousefHadder/markdown-plus.nvim";
    meta.hydraPlatforms = [ ];
  };
in
{
 programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    initLua = ''
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      vim.opt.swapfile = false
      vim.opt.autoread = true
      vim.opt.autoread = true
      vim.opt.autochdir = true
      vim.opt.wildmenu = true
      vim.opt.hidden = true
      vim.opt.shortmess:append({ a = true, t = true, I = true })
      vim.opt.compatible = false
      vim.opt.backup = false
      vim.opt.encoding = "utf-8"
      vim.opt.number = true
      vim.opt.wrap = false
      vim.opt.tabstop = 4
      vim.opt.backspace = { "indent", "eol", "start" }
      vim.opt.shiftwidth = 4
      vim.opt.softtabstop = 4
      vim.opt.smarttab = true
      vim.opt.expandtab = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.infercase = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.hlsearch = true
      vim.opt.showmatch = true
      vim.opt.list = true
      vim.opt.listchars = { tab = "▸ ", trail = "¬" }
      vim.opt.foldenable = true
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 3
      vim.opt.foldlevelstart = 3
      vim.opt.keywordprg = ":help"
      vim.cmd("syntax enable")
      vim.cmd("filetype plugin indent on")

      vim.keymap.set("n", "<Space>", function()
      return (vim.fn.foldclosed(vim.fn.line(".")) < 0) and "zc" or "zo"
      end, { expr = true, silent = true })

      vim.g.mapleader = ","
      vim.g.maplocalleader = ","


      '';
    plugins = with pkgs.vimPlugins; [
      { plugin = gruvbox-nvim; type = "lua"; config = "vim.cmd.colorscheme('gruvbox')"; }
      vim-nix
      vim-fugitive
      nerdcommenter
      delimitMate
      vim-tmux-navigator
      vim-dirdiff
      todo-txt-vim
      { plugin = nvim-treesitter.withAllGrammars; type = "lua";
        config = ''
          require('nvim-treesitter').install({
          'bash', 'c', 'cpp', 'devicetree', 'diff', 'dockerfile', 'json', 'just', 'markdown', 'markdown_inline', 'vim', 'yaml',
          })
        '';
      }
      { plugin = nvim-treesitter-textobjects; type = "lua";
        config = ''
          require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true, }, })
          local move = require("nvim-treesitter-textobjects.move")
          require("which-key").add({
           { "]", group = "Treesitter next" },
           { "[", group = "Treesitter previous" },
           { "]m", function() move.goto_next_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next function start" },
           { "]]", function() move.goto_next_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next class start" },
           { "]o", function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end, mode = { "n", "x", "o" }, desc = "Next loop start" },
           { "]s", function() move.goto_next_start("@local.scope", "locals") end, mode = { "n", "x", "o" }, desc = "Next local scope start" },
           { "]z", function() move.goto_next_start("@fold", "folds") end, mode = { "n", "x", "o" }, desc = "Next fold start" },
           { "]M", function() move.goto_next_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next function end" },
           { "][", function() move.goto_next_end("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next class end" },

           { "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous function start" },
           { "[[", function() move.goto_previous_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous class start" },
           { "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous function end" },
           { "[]", function() move.goto_previous_end("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous class end" },

           { "]d", function() move.goto_next("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next conditional" },
           { "[d", function() move.goto_previous("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous conditional" },          })
        '';
      }
      { plugin = nvim-lspconfig; type = "lua";
         config = ''
           vim.lsp.enable('bashls')
           vim.lsp.enable('clangd')
           vim.lsp.enable('cmake')
           vim.lsp.enable('pyright')
           vim.lsp.enable('nixd')
           vim.lsp.enable('rust_analyzer')
           vim.lsp.enable('yamlls')
        '';
      }
      { plugin = blink-cmp; type = "lua";
        config = ''
          require('blink.cmp').setup({
            keymap = {
              preset = 'default',
              ['<CR>'] = { 'accept', 'fallback' },
              ['<Tab>'] = { 'select_next', 'fallback' },
              ['<S-Tab>'] = { 'select_prev', 'fallback' },
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
        '';
      }
      vim-vsnip
      friendly-snippets
      { plugin = lualine-nvim; type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              section_separators = { left = "", right = "" },
              component_separators = { left = '|', right = '|' },
            },
            extensions = {'quickfix', 'nvim-tree', 'fugitive', 'trouble'},
            sections = {
              lualine_b = { 'branch', 'diff', },
              lualine_c = { 'filename', 'lsp_status', 'diagnostics' },
            }
          }
        '';
      }
      lualine-lsp-progress
      nvim-web-devicons
      { plugin = gitsigns-nvim; type = "lua"; config = "require('gitsigns').setup()"; }
      nvim-tree-lua
      telescope-nvim
      telescope-fzf-native-nvim
      { plugin = hop-nvim; type = "lua";
        config = ''
          require('hop').setup()
          vim.api.nvim_set_keymap('n', '<leader>F', "<cmd>lua require'hop'.hint_words()<cr>", {})
          '';
      }
      { plugin = numb-nvim; type = "lua"; config = "require('numb').setup()";}
      { plugin = nvim-colorizer-lua; type = "lua"; config = "require('colorizer').setup()";}
      markdown-preview-nvim
      { plugin = render-markdown-nvim; type = "lua";
        config = ''
          require('render-markdown').setup({
            completions = { lsp = { enabled = true }},
          })
        '';
      }
      { plugin = trouble-nvim; type = "lua"; config = "require('trouble').setup()"; }
      { plugin = tiny-inline-diagnostic-nvim; type = "lua"; config = "require('tiny-inline-diagnostic').setup()"; }
      { plugin = lsp_signature-nvim; type = "lua"; config = "require('lsp_signature').setup()"; }
      { plugin = which-key-nvim; type = "lua";
        config = ''
          require("which-key").add({
          -- Window
          { "<C-h>", "<cmd>wincmd h<cr>", group = "windows" },
          { "<C-j>", "<cmd>wincmd j<cr>", group = "windows" },
          { "<C-k>", "<cmd>wincmd k<cr>", group = "windows" },
          { "<C-l>", "<cmd>wincmd l<cr>", group = "windows" },
          })
        '';
      }
      { plugin = snacks-nvim; type = "lua";
        config = ''
          require('snacks').setup({
            explorer = { enabled = true },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true, timeout = 3000, },
            picker = { enabled = true },
            quickfile = { enabled = false },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            terminal = { enabled = true },
            toggle = { enabled = true },
            rename = { enabled = true },
          })
          require("which-key").add({
          -- Top Pickers & Explorer
          { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
          { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
          { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
          { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
          { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
          -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
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
          { "<leader>gg", function() Snacks.lazygit() end, desc = "Lxzygit" },
          { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
          { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
          { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
          { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
          { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
          })
        '';
      }
      { plugin = obsidian-nvim; type = "lua";
        config = ''
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
            ui = { enable = false },
            frontmatter = { enabled = false },
            note_id_func = function(title)
            if title ~= nil then
              return title:gsub(" ", " "):gsub("[\n\r]", "")
            end
              return tostring(os.date("%Y-%m-%d-%H%M%S"))
            end,
          })
          require("which-key").add({
          { "<leader>ww", "<cmd>Obsidian new_from_template note-template.md<cr>", desc = "Obsidian create a quick note"},
          { "<leader>wt", "<cmd>Obsidian template<cr>", desc = "Obsidian insert a template"},
          { "<leader>wr", "<cmd>Obsidian rename<cr>", desc = "Obsidian rename current note"},
          { "<leader>ws", "<cmd>Obsidian search<cr>", desc = "Obsidian search notes"},
          })
          '';
      }
      { plugin = markdown-plus-nvim; type = "lua"; config = "require('markdown-plus').setup()"; }
      { plugin = conform-nvim; type = "lua";
        config = ''
          require("conform").setup({
            formatters_by_ft = {
              markdown = { "prettier" },
              cpp = { "clang-format" },
              c = { "clang-format" },
              dockerfile = { "dockerfmt" }
            }
          })
          vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        '';
      }
      { plugin = opencode-nvim; type = "lua";
        config = ''
          require("which-key").add({
          { "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode…" },
          { "<C-x>", function() require("opencode").select() end, desc = "Execute opencode action…" },
          { "<C-.>", function() require("opencode").toggle() end, desc = "Toggle opencode" },
          { "go",    function() return require("opencode").operator("@this ") end, desc = "Add range to opencode" },
          { "goo",   function() return require("opencode").operator("@this ") .. "_" end, desc = "Add line to opencode" },
          })
        '';
      }
      d2-vim
      { plugin = yazi-nvim; type = "lua"; config = ''require("which-key").add({{ "<leader>e", function() require("yazi").yazi() end, desc = "Yazi" }})'';}
    ];
    extraPackages = with pkgs; [
      nixd
      tree-sitter
      clang-tools
      ctags
      pandoc
      pyright
      yaml-language-server
      bash-language-server
      cmake-language-server
      rust-analyzer
      cargo
      rustc
      ripgrep
      fd
      ninja
      bear
      cmake
      lazygit
      prettier
      clang-tools
      dockerfmt
    ];
  };
}
