-- Load LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "olimorris/onedarkpro.nvim",            -- Colorscheme onedarkpro ported from vscode
  "vimpostor/vim-tpipeline",              -- Status line compatible with tmux
  "nvim-tree/nvim-web-devicons",          -- File icons
  "lewis6991/gitsigns.nvim",              -- Git status
  "romgrk/barbar.nvim",                   -- Tabline
  {
    "nvim-telescope/telescope-file-browser.nvim", -- File browser for Telescope
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-tree/nvim-tree.lua",            -- File explorer
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "nvim-treesitter/nvim-treesitter",    -- Syntax highlighting
    build = ":TSUpdate"
  },
  {
    "nvim-lualine/lualine.nvim",          -- Status line
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "williamboman/mason.nvim",            -- Mason LSP plugins
    "williamboman/mason-lspconfig.nvim",  -- Mason LSP plugins easy configuration
    "neovim/nvim-lspconfig",              -- LSP Configuaration
  },
  "github/copilot.vim",                   -- GitHub Copilot
  -- autocompletion
  "hrsh7th/nvim-cmp",                     -- completion plugin
  "hrsh7th/cmp-buffer",                   -- source for text in buffer
  "hrsh7th/cmp-path",                     -- source for file system paths
  "hrsh7th/cmp-nvim-lsp",                 -- source for LSP completions
  "hrsh7th/cmp-nvim-lua",                 -- source for neovim lua API
  "hrsh7th/cmp-nvim-lsp-signature-help",  -- source for function signatures
  "hrsh7th/cmp-emoji",                    -- source for emojis
  "hrsh7th/cmp-cmdline",                  -- source for command line
  -- snippets
  "L3MON4D3/LuaSnip",                     -- snippet engine
  "saadparwaiz1/cmp_luasnip",             -- for autocompletion
  "rafamadriz/friendly-snippets",         -- useful snippets
  -- auto-closing
  "windwp/nvim-autopairs",                -- auto-closing pairs
})

vim.o.number = true                       -- Show line numbers
vim.o.numberwidth = 6                     -- Column of line number
vim.o.wrap = false                        -- Disable line wrap
vim.o.tabstop = 2                         -- Number of spaces per tab
vim.o.softtabstop = 2                     -- Tab key inserts 2 spaces
vim.o.expandtab = true                    -- Tab uses spaces
vim.o.smartindent = true                  -- Enable auto indent
vim.o.shiftwidth = 2                      -- Number of spaces for autoindent
vim.o.smartcase = true                    -- Enable smart case searching
vim.o.ignorecase = true                   -- Ignore case in searches
vim.o.incsearch = true                    -- Incremeantal search enable
vim.o.hlsearch = false                    -- Disable search highlight
vim.o.termguicolors = true                -- Enable 24-bit RGB colors
vim.o.mouse = "a"                         -- Enable mouse support
vim.o.guicursor = "n-c-o:block,i-v:ver25" -- Set cursor style


-- Colorscheme
require("onedarkpro").setup({ --Change theme config
  options = {
    cursorline = false,
    transparency = true
  }
})
vim.cmd("colorscheme onedark")

-- Lualine configuration
local onedarkpro_lua = require("lualine.onedark")
require('lualine').setup {
  options = {
    theme = onedarkpro_lua,
    section_separators = { left = '', right = '' }, -- Round borders
    component_separators = { left = '', right = '' } -- Round borders
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 'filetype' },
    lualine_z = { 'location' }
  }
}
-- Set the status line to match tmux status line
vim.cmd("set stl=%!tpipeline#stl#line()")

-- Optional: Clipboard Integration
vim.o.clipboard = "unnamedplus" -- Use system clipboard

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    side = "right", -- Set the nvim-tree pane to open on the right
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,     -- Show hidden files
  },
  update_focused_file = { -- Set nvim-tree to open in the current dir
    enable = true,
    update_cwd = true,
  },
  respect_buf_cwd = true,
})

-- Set space as the leader key
vim.g.mapleader = " "

-- Unmap space in normal mode to prevent it from advancing the cursor
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

-- Custom mappings using the leader key

-- Quit Neovim
vim.api.nvim_set_keymap('n', '<leader>q', ':q!<CR>', { noremap = true, silent = true })

-- Open NvimTree
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Find files using Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })

-- Grep files using Telescope
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- Enable selection with direction keys in visual mode
vim.api.nvim_set_keymap('v', '<Up>', 'v<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Down>', 'v<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Left>', 'v<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Right>', 'v<Right>', { noremap = true, silent = true })

-- Map Ctrl+C to yank in normal and visual mode
vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+V to paste in normal and visual mode
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-v>', '"+p', { noremap = true, silent = true })

-- Map Ctrl+Z to undo in normal and visual mode
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-z>', 'u', { noremap = true, silent = true })

-- Map Shift+Ctrl+Z to redo in normal and visual mode
vim.api.nvim_set_keymap('n', '<C-S-z>', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-S-z>', '<C-r>', { noremap = true, silent = true })

-- Map Option+Up to go to the top of the page
vim.api.nvim_set_keymap('n', '<A-Up>', 'gg', { noremap = true, silent = true })

-- Map Option+Down to go to the bottom of the page
vim.api.nvim_set_keymap('n', '<A-Down>', 'G', { noremap = true, silent = true })

-- Map Option+Left to go to the beginning of the line
vim.api.nvim_set_keymap('n', '<A-Left>', '0', { noremap = true, silent = true })

-- Map Option+Right to go to the end of the line
vim.api.nvim_set_keymap('n', '<A-Right>', '$', { noremap = true, silent = true })

-- Remap Ctrl+A to select all text
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })

-- Remap Backspace in visual mode to delete the selected text
vim.api.nvim_set_keymap('v', '<BS>', 'd', { noremap = true, silent = true })

-- Enable selection with Shift+direction keys in insert mode
vim.api.nvim_set_keymap('i', '<S-Up>', '<C-o>v<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Down>', '<C-o>v<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Left>', '<C-o>v<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-Right>', '<C-o>v<Right>', { noremap = true, silent = true })

-- Map Ctrl+N to open a new tab
vim.api.nvim_set_keymap('n', '<C-n>', ':tabnew<CR>', { noremap = true, silent = true })

-- Map Ctrl+Shift+N to close the current tab
vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })

-- Map Ctrl+F to open a Telescope menu to select the search mode
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })

-- Map Ctrl+L to toggle the nvim-tree pane
vim.api.nvim_set_keymap('n', '<C-l>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Map Ctrl+S to save the current file
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })

-- Remap Ctrl-click to go to definition
vim.api.nvim_set_keymap('n', '<C-LeftMouse>', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

-- Make commands case insensitive
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("QA", "qa", {})

-- Automatically reload the file if it is changed outside of NVIM
vim.api.nvim_create_augroup("auto_read", { clear = true })
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  group = "auto_read",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded!",
      vim.log.levels.WARN, { title = "nvim-config" })
  end,
})

-- LSP Config
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "clangd", "jdtls", "pyright" }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig").lua_ls.setup {
  capabilities = capabilities
}
require 'lspconfig'.clangd.setup {
  capabilities = capabilities
}
require("lspconfig").jdtls.setup {
  capabilities = capabilities
}
require("lspconfig").pyright.setup {
  capabilities = capabilities
}

-- Setup nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged },
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
    }),
    documentation = cmp.config.window.bordered({
      border = 'rounded',
      winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
    }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'emoji' },
  }, {
    { name = 'buffer' },
  })
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Use buffer source for '/' and '?'.
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Setup nvim-autopairs.
require('nvim-autopairs').setup {}

-- Integrate nvim-autopairs with nvim-cmp.
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Set transparency for Pmenu
vim.cmd [[
  highlight Pmenu guibg=NONE
  highlight PmenuSel guibg=NONE
]]

-- Setup nvim-treesitter
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "cpp", "python", "java", "yaml", "markdown", "markdown_inline", "lua", "rust", "sql", "vim", "vimdoc" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
