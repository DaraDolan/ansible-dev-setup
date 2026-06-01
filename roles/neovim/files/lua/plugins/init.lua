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
            -- Copilot status
            {
              function()
                local copilot_status = vim.g.copilot_enabled
                if copilot_status == 1 then
                  return " "
                else
                  return ""
                end
              end,
              color = function()
                local copilot_status = vim.g.copilot_enabled
                if copilot_status == 1 then
                  return { fg = '#6CC644' } -- Green when enabled
                else
                  return { fg = '#F97583' } -- Red when disabled
                end
              end,
            },
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
            ["<leader>e"] = "close_window",
            ["<leader>n"] = "close_window",
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
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      local parsers = {
        "lua", "vim", "vimdoc", "query", -- Neovim
        "php", "html", "css", "javascript", "typescript", "tsx", -- Web
        "json", "yaml", "markdown", "markdown_inline", -- Data & Docs
        "bash", "python", -- Scripts
        "blade", "vue", -- Laravel specific
      }

      for _, parser in ipairs(parsers) do
        ts.install(parser)
      end

      -- Build filetype patterns from installed parsers
      local patterns = {}
      for _, parser in ipairs(parsers) do
        local fts = vim.treesitter.language.get_filetypes(parser)
        for _, ft in ipairs(fts) do
          table.insert(patterns, ft)
        end
      end

      -- Enable treesitter highlighting and indentation via autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = patterns,
        callback = function(ev)
          vim.treesitter.start(ev.buf)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Text manipulation plugins
  {
    "kylechui/nvim-surround",      -- Lua replacement for vim-surround
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
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
    build = function()
      vim.cmd("silent! !cd " .. vim.fn.expand("%:p:h") .. " && composer install --no-dev --optimize-autoloader")
    end,
  },
  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      -- Load custom snippets from config dir
      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath('config') .. '/snippets' }
      })
      luasnip.config.setup({})
    end,
  },
  { "saadparwaiz1/cmp_luasnip" }, -- LuaSnip completion source for nvim-cmp
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
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
    },
    config = function()
      require("mason").setup()

      -- Use modern vim.lsp.config API (Neovim 0.11+) to avoid deprecation warnings
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Helper function to find project root
      local function root_pattern(...)
        local patterns = {...}
        return function(fname)
          for _, pattern in ipairs(patterns) do
            local match = vim.fs.find(pattern, { path = fname, upward = true })[1]
            if match then
              return vim.fs.dirname(match)
            end
          end
          return vim.fs.dirname(fname)
        end
      end

      -- PHP (Intelephense Premium)
      -- Read license key
      local license_file = vim.fn.expand("~/.config/intelephense/licence.txt")
      local license_key = ""
      if vim.fn.filereadable(license_file) == 1 then
        license_key = vim.trim(vim.fn.readfile(license_file)[1])
      end

      vim.lsp.config.intelephense = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/intelephense"), "--stdio" },
        filetypes = { "php", "blade", "php_only" },
        root_markers = { "composer.json", ".git" },
        capabilities = capabilities,
        init_options = {
          licenceKey = license_key,
          storagePath = vim.fn.expand("~/.cache/intelephense"),
        },
        settings = {
          intelephense = {
            files = {
              maxSize = 5000000,
              associations = { "*.php", "*.blade.php" },
              exclude = {
                "**/.git/**",
                "**/node_modules/**",
                "**/storage/framework/cache/**",
                "**/storage/framework/views/**",
              },
            },
            environment = {
              includePaths = { vim.fn.expand("~/.composer/vendor") },
            },
          },
        },
      }

      -- HTML
      vim.lsp.config.html = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-html-language-server"), "--stdio" },
        filetypes = { "html" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- CSS
      vim.lsp.config.cssls = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-css-language-server"), "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- Tailwind CSS
      vim.lsp.config.tailwindcss = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/tailwindcss-language-server"), "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "blade" },
        root_markers = { "tailwind.config.js", "tailwind.config.ts", ".git" },
        capabilities = capabilities,
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/typescript-language-server"), "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
      }

      -- Emmet
      vim.lsp.config.emmet_ls = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/emmet-ls"), "--stdio" },
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "blade" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- JSON
      vim.lsp.config.jsonls = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-json-language-server"), "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
        capabilities = capabilities,
      }

      -- Python
      vim.lsp.config.pylsp = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/pylsp") },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {'W391'},
                maxLineLength = 100
              }
            }
          }
        },
        capabilities = capabilities,
      }

      -- ESLint
      vim.lsp.config.eslint = {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-eslint-language-server"), "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.cjs", "eslint.config.js", "package.json", ".git" },
        capabilities = capabilities,
        settings = {
          validate = "on",
          packageManager = "npm",
          useESLintClass = false,
          experimental = { useFlatConfig = false },
          codeActionOnSave = { enable = false, mode = "all" },
          format = false, -- Let conform handle formatting
          workingDirectory = { mode = "location" },
        },
      }

      -- Enable LSP servers for their configured filetypes
      vim.lsp.enable({ 'intelephense', 'html', 'cssls', 'tailwindcss', 'ts_ls', 'emmet_ls', 'jsonls', 'pylsp', 'eslint' })
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
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
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
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
        }, {
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        })
      })
    end,
  },

  -- Linting (nvim-lint runs linters on save; conform handles formatting)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        php = { "phpstan" },
      }
      -- Run linter on save and when entering a buffer
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
      vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, { desc = "Run linter" })
    end,
  },

  -- Laravel Specific
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-neotest/nvim-nio",
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

  -- Formatting (conform.nvim - modern replacement for none-ls)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- PHP - Laravel Pint (install globally: composer global require laravel/pint)
        php = { "pint" },
        blade = { "pint" },

        -- JavaScript/TypeScript/React (install globally: npm install -g prettier)
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        -- Frontend
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
      -- Format on save
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
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

  -- ===============================================
  -- MIND-BENDING ENHANCEMENTS START HERE
  -- ===============================================

  -- Beautiful UI enhancements
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end,
  },

  -- Gorgeous notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        stages = "fade_in_slide_out",
        timeout = 3000,
      })
      vim.notify = require("notify")
    end,
  },

  -- Alternative beautiful colorschemes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          mini = false,
        },
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
    end,
  },

  -- Dashboard/Start screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Set header
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
        "                 [ Laravel + React Pro ]            ",
      }

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰍉  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Find project", ":Telescope projects<CR>"),
        dashboard.button("w", "  Find word", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
        dashboard.button("s", "  Restore session", ":SessionRestore<CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Set footer
      local function footer()
        local total_plugins = #vim.tbl_keys(require("lazy").plugins())
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
      end

      dashboard.section.footer.val = footer()

      -- Apply config
      alpha.setup(dashboard.config)
    end,
  },

  -- Advanced file management with Oil.nvim
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false, -- Don't override netrw completely
        columns = {
          "icon",
        },
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            { "type", "asc" },
            { "name", "asc" },
          },
        },
      })
      -- Keymap to open oil (alternative file manager)
      vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "Open Oil file manager" })
    end,
  },

  -- File navigation with Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon next" })
    end,
  },

  -- Advanced search and replace
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Custom terminal commands
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true, desc = "LazyGit"})

      local claude = Terminal:new({ cmd = "claude", hidden = true, direction = "float" })

      function _CLAUDE_TOGGLE()
        claude:toggle()
      end

      vim.keymap.set("n", "<leader>ai", "<cmd>lua _CLAUDE_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Claude Code"})
    end,
  },

  -- Enhanced git integration
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      require("diffview").setup()
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" },
    },
  },

  -- Session management
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = false,
        auto_session_enable_last_session = true,
        auto_session_create_enabled = true,
        auto_restore_enabled = false,
        auto_save_enabled = true,
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })

      vim.keymap.set("n", "<Leader>ss", "<Cmd>SessionRestore<CR>", {
        noremap = true,
        desc = "Restore session"
      })
    end,
  },

  -- Which-key for discovering keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- Trouble for diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Enhanced folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      opts.fold_virt_text_handler = handler
      require("ufo").setup(opts)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end,
  },

  -- Zen mode for distraction-free coding
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default tab mapping
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- Filetype configuration
      vim.g.copilot_filetypes = {
        ["*"] = false,
        ["php"] = true,
        ["blade"] = true,
        ["javascript"] = true,
        ["typescript"] = true,
        ["vue"] = true,
        ["jsx"] = true,
        ["tsx"] = true,
        ["html"] = true,
        ["css"] = true,
        ["lua"] = true,
        ["python"] = true,
        ["markdown"] = true,
        ["json"] = true,
        ["TelescopePrompt"] = false,
        ["fugitive"] = false,
        ["gitcommit"] = false,
        ["help"] = false,
      }

      -- Alt+hjkl keybindings for Copilot suggestions
      vim.keymap.set("i", "<M-l>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion"
      })

      vim.keymap.set("i", "<M-j>", "<Plug>(copilot-next)", {
        desc = "Next Copilot suggestion"
      })

      vim.keymap.set("i", "<M-k>", "<Plug>(copilot-previous)", {
        desc = "Previous Copilot suggestion"
      })

      vim.keymap.set("i", "<M-h>", "<Plug>(copilot-dismiss)", {
        desc = "Dismiss Copilot suggestion"
      })

      -- Toggle Copilot functionality
      vim.api.nvim_create_user_command("CopilotToggle", function()
        if vim.g.copilot_enabled == 0 then
          vim.cmd("Copilot enable")
          vim.g.copilot_enabled = 1
          vim.notify("Copilot enabled", vim.log.levels.INFO)
        else
          vim.cmd("Copilot disable")
          vim.g.copilot_enabled = 0
          vim.notify("Copilot disabled", vim.log.levels.WARN)
        end
      end, { desc = "Toggle GitHub Copilot" })

      -- Initialize Copilot as enabled
      vim.g.copilot_enabled = 1
    end,
  },
}
