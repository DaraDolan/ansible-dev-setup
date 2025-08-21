-- Plugin definitions for lazy.nvim
return {
  -- Colorscheme
  {
    "arcticicestudio/nord-vim", -- Your existing Nord theme
    lazy = false,              -- Load during startup
    priority = 1000,           -- Load this first
    config = function()
      -- Apply colorscheme
      vim.cmd.colorscheme("nord")
      -- Nord specific configurations from your theme.vim
      vim.g.nord_cursor_line_number_background = 1
      vim.g.nord_uniform_status_lines = 1
      vim.g.nord_bold_vertical_split_line = 1
      vim.g.nord_uniform_diff_background = 1
      vim.g.nord_italic_comments = 1
      -- Configure Signify signs
      vim.cmd([[
        highlight SignifySignAdd ctermbg=none ctermfg=green
        highlight SignifySignChange ctermbg=none ctermfg=yellow
        highlight SignifySignDelete ctermbg=none ctermfg=red
      ]])
    end,
  },

  -- Improved status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "nord",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}}},
          lualine_c = {'filename'},
          lualine_x = {
            {'diagnostics', sources = {'nvim_diagnostic'}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}},
            'filetype'
          },
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "  ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
          file_ignore_patterns = {"node_modules", "vendor", ".git"},
        },
        pickers = {
          find_files = {
            find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"},
          },
          project_history = {
            cwd_only = true,
          },
        },
      })
      -- Load telescope extensions
      pcall(telescope.load_extension, "fzf")
      -- Define custom functions similar to your telescope.lua
      -- This will enable your <Leader><Leader>d for dotfiles
      _G.search_dotfiles = function()
        require("telescope.builtin").find_files({
          prompt_title = "Dotfiles",
          cwd = "~/.config/nvim",
          hidden = true,
        })
      end
      vim.keymap.set("n", "<Leader><Leader>d", function() _G.search_dotfiles() end, { desc = "Search dotfiles" })
    end,
  },

  -- Git integrations
  {
    "tpope/vim-fugitive", -- Git commands
    dependencies = {
      "tpope/vim-rhubarb", -- GitHub extension
    },
  },
  {
    "lewis6991/gitsigns.nvim", -- Modern replacement for vim-signify
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr})

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr})

          -- Actions
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr})
          vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {buffer=bufnr})
          vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr})
          vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer=bufnr})
          vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {buffer=bufnr})
        end
      })
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "toggle_node",
            ["o"] = "open",
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
          }
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
          },
          follow_current_file = {
            enabled = true,
          },
        },
      })
    end,
  },

  -- Treesitter for improved syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", -- Neovim
          "php", "html", "css", "javascript", "typescript", "tsx", "jsx", -- Web
          "json", "yaml", "markdown", "markdown_inline", -- Data & Docs
          "bash", "python", -- Scripts
          "blade", "vue", -- Laravel specific
        },
        sync_install = false,
        auto_install = true,
        modules = {},
        ignore_install = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- Text manipulation plugins
  { "tpope/vim-surround" },        -- Surroundings manipulation
  { "tpope/vim-unimpaired" },      -- Pairs of handy bracket mappings
  { "tpope/vim-projectionist" },   -- Project configuration
  -- Commenting plugin
  {
    "numToStr/Comment.nvim",       -- Modern commenting plugin
    config = function()
      require("Comment").setup()
    end,
  },
  -- Testing support (preserving your vim-test config)
  {
    "vim-test/vim-test",
    config = function()
      vim.g['test#php#phpunit#executable'] = 'phpunit'
      if vim.fn.has('nvim') == 1 then
        vim.g['test#strategy'] = 'neovim'
      else
        vim.g['test#strategy'] = 'vimterminal'
      end
    end,
  },
  -- PHP specific tools
  {
    "phpactor/phpactor",
    ft = "php",
    build = "composer install --no-dev -o",
  },
  -- EditorConfig support
  { "editorconfig/editorconfig-vim" },
  -- Snippets
  {
    "hrsh7th/vim-vsnip",
    dependencies = {
      "hrsh7th/vim-vsnip-integ",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/snippets'
    end,
  },
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        scope = { enabled = true },
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "intelephense", -- PHP
          "html",         -- HTML
          "cssls",        -- CSS
          "tailwindcss",  -- Tailwind CSS
          "tsserver",     -- TypeScript/JavaScript
          "emmet_ls",     -- Emmet
          "jsonls",       -- JSON
        },
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- PHP
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
            environment = {
              includePaths = {
                vim.fn.expand("~/.composer/vendor"),
              },
            },
          },
        },
      })

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "blade" },
      })

      -- TypeScript/JavaScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- Emmet
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "blade" },
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end,
  },

  -- Laravel Specific
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>" },
      { "<leader>lr", ":Laravel routes<cr>" },
      { "<leader>lm", ":Laravel related<cr>" },
    },
    event = { "VeryLazy" },
    config = function()
      require("laravel").setup()
    end,
  },

  -- Blade Syntax
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },

  -- React/JSX/TSX Support
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "blade" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Tailwind CSS Tools
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },

  -- Better PHP syntax
  {
    "StanAngeloff/php.vim",
    ft = "php",
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
      -- Integration with cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- Formatting
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- PHP
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.diagnostics.phpcs,
          
          -- JavaScript/TypeScript
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "yaml", "markdown" },
          }),
          
          -- CSS/Tailwind
          null_ls.builtins.formatting.stylelint,
        },
      })
    end,
  },

  -- File icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          blade = {
            icon = "",
            color = "#f1502f",
            name = "Blade"
          },
        },
      })
    end,
  },
}
