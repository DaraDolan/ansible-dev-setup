-- Key mappings
local map = vim.keymap.set

-- Helper function for mapping
local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Escape with jj
keymap("i", "jj", "<ESC>")

-- Write file
keymap("n", "<Leader>w", ":w<CR>")
keymap("i", "jw", "<Esc>:w<CR>")

-- Telescope mappings (preserving your existing mappings.vim bindings)
keymap("n", "<Leader>f", "<cmd>Telescope git_files<CR>", { desc = "Find Git Files" })
keymap("n", "<Leader>F", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
keymap("n", "<Leader>b", "<cmd>Telescope buffers sort_lastused=true<CR>", { desc = "Find Buffers" })
keymap("n", "<Leader>m", "<cmd>Telescope git_status<CR>", { desc = "Git Status" })
keymap("n", "<Leader>h", "<cmd>Telescope oldfiles<CR>", { desc = "History/Old Files" })
keymap("n", "<Leader>H", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
keymap("n", "<Leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
keymap("n", "<Leader>t", "<cmd>Telescope current_buffer_tags<CR>", { desc = "Buffer Tags" })
keymap("n", "<Leader>l", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Buffer Lines" })
keymap("n", "<Leader>C", "<cmd>Telescope commands<CR>", { desc = "Commands" })
keymap("n", "<Leader>:", "<cmd>Telescope command_history<CR>", { desc = "Command History" })
keymap("n", "<Leader>s", "<cmd>Telescope filetypes<CR>", { desc = "Filetypes" })
keymap("n", "<Leader><Leader>h", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" })
keymap("n", "<Leader><Leader>t", "<cmd>Telescope<CR>", { desc = "Telescope" })

-- Git mappings
keymap("n", "<Leader>G", "<cmd>Git<CR>", { desc = "Git Status" })
keymap("n", "<Leader><Leader>go", "<cmd>GBrowse<CR>", { desc = "Open in GitHub" })

-- Quickly append semicolon or comma
keymap("i", ";;", "<Esc>A;<Esc>")
keymap("i", ",,", "<Esc>A,<Esc>")

-- Test mappings
keymap("n", "<leader>tn", "<cmd>TestNearest<CR>", { desc = "Test Nearest" })
keymap("n", "<leader>tf", "<cmd>TestFile<CR>", { desc = "Test File" })
keymap("n", "<leader>ts", "<cmd>TestSuite<CR>", { desc = "Test Suite" })
keymap("n", "<leader>tl", "<cmd>TestLast<CR>", { desc = "Test Last" })
keymap("n", "<leader>tv", "<cmd>TestVisit<CR>", { desc = "Test Visit" })

-- Text manipulation from your mappings.vim
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })
keymap("n", "<leader>j", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<leader>k", ":m .-2<CR>==", { desc = "Move line up" })
keymap("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
keymap("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

-- Helpful editing mappings
keymap("i", "<c-u>", "<esc>viwUA", { desc = "Uppercase word" })
keymap("n", '<leader>"', 'viw<esc>a"<esc>bi"<esc>lel', { desc = 'Surround word with "' })
keymap("n", "<leader>'", "viw<esc>a'<esc>bi'<esc>lel", { desc = "Surround word with '" })
keymap("v", "<leader>'", "<esc>`<i'<esc>`>a'<esc>", { desc = "Surround selection with '" })

-- H and L go to start and end of line
keymap("n", "H", "0", { desc = "Go to start of line" })
keymap("n", "L", "$", { desc = "Go to end of line" })
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- Keep cursor centered
keymap("n", "n", "nzzzv", { desc = "Next search result centered" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result centered" })
keymap("n", "J", "mzJ`z", { desc = "Join lines centered" })

-- Undo breakpoints
keymap("i", ",", ",<c-g>u", { desc = "Undo breakpoint at comma" })
keymap("i", ".", ".<c-g>u", { desc = "Undo breakpoint at period" })
keymap("i", "!", "!<c-g>u", { desc = "Undo breakpoint at exclamation" })
keymap("i", "?", "?<c-g>u", { desc = "Undo breakpoint at question mark" })

-- Jumplist mutations
keymap("n", "k", '(v:count > 5 ? "m\'" . v:count : "") . "k"', { expr = true, desc = "Add jump on large movement up" })
keymap("n", "j", '(v:count > 5 ? "m\'" . v:count : "") . "j"', { expr = true, desc = "Add jump on large movement down" })

-- Terminal mode escape
if vim.fn.has('nvim') == 1 then
  keymap("t", "<C-o>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
end

-- Buffer navigation
keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Split navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Quick edit important files
keymap("n", "<leader>ve", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit neovim config" })

-- File explorer
keymap("n", "<Leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Format file
keymap("n", "<Leader>p", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format file" })

-- LSP keybindings
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover documentation" })
keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help" })
keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code actions" })
keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostics" })
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Previous diagnostic" })
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Next diagnostic" })

-- Claude Code integration shortcuts
keymap("n", "<leader>cc", "<cmd>!claude .<CR>", { desc = "Open project in Claude Code" })
keymap("n", "<leader>ce", "<cmd>!claude edit %<CR>", { desc = "Edit current file with Claude Code" })

-- Laravel specific shortcuts (when in Laravel project)
keymap("n", "<leader>lc", "<cmd>!php artisan make:controller ", { desc = "Make controller" })
keymap("n", "<leader>lm", "<cmd>!php artisan make:model ", { desc = "Make model" })
keymap("n", "<leader>lmi", "<cmd>!php artisan make:migration ", { desc = "Make migration" })
keymap("n", "<leader>ls", "<cmd>!php artisan serve<CR>", { desc = "Start Laravel server" })
keymap("n", "<leader>lt", "<cmd>!php artisan test<CR>", { desc = "Run Laravel tests" })

-- React/Frontend development shortcuts
keymap("n", "<leader>nd", "<cmd>!npm run dev<CR>", { desc = "Start npm dev server" })
keymap("n", "<leader>nb", "<cmd>!npm run build<CR>", { desc = "Build for production" })
keymap("n", "<leader>ni", "<cmd>!npm install<CR>", { desc = "Install npm dependencies" })

-- Tailwind CSS utilities
keymap("n", "<leader>tw", "<cmd>!npx tailwindcss init<CR>", { desc = "Initialize Tailwind CSS" })
