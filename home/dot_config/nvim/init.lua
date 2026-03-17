-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })

-- Options
local opt = vim.opt
opt.number         = true
opt.numberwidth    = 4
opt.relativenumber = false
opt.wrap           = false
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.tabstop        = 2
opt.softtabstop    = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.smartindent    = true
opt.smartcase      = true
opt.ignorecase     = true
opt.incsearch      = true
opt.hlsearch       = false
opt.termguicolors  = true
opt.mouse          = "a"

-- macOS clipboard
if vim.fn.has("mac") == 1 then
  opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name  = "OSC 52",
    copy  = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
else
  opt.clipboard = "unnamedplus"
end

if vim.fn.has("macunix") == 1 then
  vim.g.clipboard = {
    name  = "macOS",
    copy  = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
    paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
    cache_enabled = 0,
  }
end
opt.signcolumn     = "yes"         -- always show; prevents layout shifts
opt.updatetime     = 200           -- faster CursorHold / gitsigns
opt.timeoutlen     = 300           -- faster which-key popup
opt.splitright     = true
opt.splitbelow     = true
opt.undofile       = true          -- persistent undo
opt.undodir        = vim.fn.stdpath("data") .. "/undo"
opt.completeopt    = "menu,menuone,noselect"
opt.pumheight      = 10
opt.showmode       = false         -- lualine shows the mode
opt.laststatus     = 3             -- global status line (nvim 0.7+)
opt.cursorline     = false
opt.guicursor      = "n-c-o:block,i-v:ver25"
opt.fileencoding   = "utf-8"

-- Plugins
require("lazy").setup({

  -- Colorscheme
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      require("onedarkpro").setup({
        options = {
          cursorline           = false,
          transparency         = true,
          lualine_transparency = true,
        },
        highlights = {
          Pmenu    = { bg = "NONE" },
          PmenuSel = { bg = "NONE", bold = true },
        },
      })
      vim.cmd("colorscheme onedark")
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme                = "onedark",
          section_separators   = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus         = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },  -- show relative path
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
      -- Sync status line to tmux via tpipeline
      vim.cmd("set stl=%!tpipeline#stl#line()")
    end,
  },
  { "vimpostor/vim-tpipeline" },

  -- Tabline
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation     = true,
      insert_at_end = true,
      icons = {
        button = "",
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true },
          [vim.diagnostic.severity.WARN]  = { enabled = false },
        },
      },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h",         gs.next_hunk,                                  "Next hunk")
        map("n", "[h",         gs.prev_hunk,                                  "Prev hunk")
        map("n", "<leader>hp", gs.preview_hunk,                               "Preview hunk")
        map("n", "<leader>hr", gs.reset_hunk,                                 "Reset hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,  "Blame line")
      end,
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sort_by  = "case_sensitive",
      view     = { width = 30, side = "right" },
      renderer = { group_empty = true },
      filters  = { dotfiles = false },
      update_focused_file = { enable = true, update_cwd = true },
      respect_buf_cwd     = true,
    },
  },

  -- Yazi
  {
    "mikavilpas/yazi.nvim",
    event        = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      { "<leader>y",  "<cmd>Yazi<cr>",        desc = "Yazi (current file)" },
      { "<leader>Y",  "<cmd>Yazi cwd<cr>",    desc = "Yazi (cwd)" },
      { "<C-up>",     "<cmd>Yazi toggle<cr>", desc = "Yazi (last session)" },
    },
    opts = {
      open_for_directories = false,
      keymaps = { show_help = "<F1>" },
    },
  },

  -- Snacks (required by yazi.nvim)
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy     = false,
    opts = {
      bigfile   = { enabled = true },
      notifier  = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      words     = { enabled = true },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "jvgrootveld/telescope-zoxide",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix   = " ",
          selection_caret = " ",
          path_display    = { "truncate" },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case",
            "--hidden", "--glob=!.git/",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob=!.git/" },
          },
        },
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,
            override_file_sorter    = true,
            case_mode               = "smart_case",
          },
          zoxide = { prompt_title = "Zoxide" },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("zoxide")
    end,
  },

  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      winopts = {
        height = 0.85, width = 0.80,
        preview = {
          default    = "bat",
          border     = "border",
          horizontal = "right:50%",
        },
      },
      files = { cmd = "rg --files --hidden --glob '!.git/'" },
      grep  = { cmd = "rg --vimgrep --hidden --glob '!.git/'" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSInstallSync" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash","c","cpp","css","dockerfile","html","java",
        "javascript","json","lua","markdown","markdown_inline",
        "python","regex","rust","scss","sql","swift","toml",
        "typescript","vim","vimdoc","yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },

  -- Markdown
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft   = { "markdown" },
    opts = {
      heading  = { enabled = true },
      code     = { enabled = true, style = "full" },
      bullet   = { enabled = true },
      checkbox = { enabled = true },
    },
  },

  -- Markdown — GFM (<leader>mp)
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft    = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys  = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown preview (browser)" },
    },
    config = function()
      vim.g.mkdp_theme           = "dark"
      vim.g.mkdp_auto_close      = 1   -- close tab when leaving md buffer
      vim.g.mkdp_combine_preview = 1   -- reuse single browser tab
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd  = "Mason",
    opts = { ui = { border = "rounded" } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", "clangd", "jdtls", "pyright",
        "tailwindcss", "ts_ls", "cssls", "html",
      },
      automatic_installation = true,
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.diagnostic.config({
        virtual_text     = { prefix = "●" },
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = true,
        float = { border = "rounded", source = "always", header = "", prefix = "" },
      })

      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local bufnr = ev.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end
          -- Navigation
          map("gd",          vim.lsp.buf.definition,                          "Go to definition")
          map("gD",          vim.lsp.buf.declaration,                         "Go to declaration")
          map("gr",          vim.lsp.buf.references,                          "Go to references")
          map("gi",          vim.lsp.buf.implementation,                      "Go to implementation")
          map("gt",          vim.lsp.buf.type_definition,                     "Go to type definition")
          -- Docs
          map("K",           vim.lsp.buf.hover,                               "Hover docs")
          map("<C-k>",       vim.lsp.buf.signature_help,                      "Signature help")
          -- Actions
          map("<leader>rn",  vim.lsp.buf.rename,                              "Rename symbol")
          map("<leader>ca",  vim.lsp.buf.code_action,                         "Code action")
          map("<leader>cf",  function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          -- Diagnostics
          map("<leader>d",   vim.diagnostic.open_float,                       "Show diagnostic float")
          map("[d",          vim.diagnostic.goto_prev,                        "Prev diagnostic")
          map("]d",          vim.diagnostic.goto_next,                        "Next diagnostic")
          map("<leader>dl",  vim.diagnostic.setloclist,                       "Diagnostic list")
          -- Ctrl-click → definition
          vim.keymap.set("n", "<C-LeftMouse>",
            "<cmd>lua vim.lsp.buf.definition()<CR>",
            { buffer = bufnr, noremap = true, silent = true })
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Shared defaults applied to every server
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Per-server settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              library         = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = { typeCheckingMode = "basic", autoSearchPaths = true },
          },
        },
      })

      vim.lsp.enable({
        "lua_ls",
        "clangd",
        "jdtls",
        "pyright",
        "tailwindcss",
        "ts_ls",
        "cssls",
        "html",
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      local kind_icons = {
        Text = "󰊄", Method = "󰆧", Function = "󰊕", Constructor = "",
        Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
        Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
        Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
        File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
        Constant = "󰏿", Struct = "", Event = "", Operator = "󰆕",
        TypeParameter = "󰅲",
      }

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
            return vim_item
          end,
        },
        window = {
          completion    = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded" }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "emoji" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      win = { border = "rounded" },
    },
  },

}, {
  ui = { border = "rounded" },
  checker          = { enabled = true, notify = false },
  change_detection = { notify = false },
})

-- ── Keymaps ──────────────────────────────────────────────────
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Editor basics
map("n", "<leader>q",  ":q!<CR>",          "Force quit")
map("n", "<C-s>",      ":w<CR>",            "Save file")
map("i", "<C-s>",      "<Esc>:w<CR>a",      "Save file")
map("n", "<C-a>",      "ggVG",              "Select all")

-- Navigation
map("n", "<A-Up>",    "gg", "Top of file")
map("n", "<A-Down>",  "G",  "Bottom of file")
map("n", "<A-Left>",  "0",  "Start of line")
map("n", "<A-Right>", "$",  "End of line")

-- Clipboard
map("n", "<C-c>", '"+y', "Copy to clipboard")
map("v", "<C-c>", '"+y', "Copy to clipboard")
map("n", "<C-v>", '"+p', "Paste from clipboard")
map("v", "<C-v>", '"+p', "Paste from clipboard")

-- Undo / Redo
map("n", "<C-z>",   "u",     "Undo")
map("v", "<C-z>",   "u",     "Undo")
map("n", "<C-S-z>", "<C-r>", "Redo")
map("v", "<C-S-z>", "<C-r>", "Redo")

-- Visual selection with arrow keys
map("v", "<Up>",    "v<Up>",    "Extend selection up")
map("v", "<Down>",  "v<Down>",  "Extend selection down")
map("v", "<Left>",  "v<Left>",  "Extend selection left")
map("v", "<Right>", "v<Right>", "Extend selection right")

-- Insert mode: Shift+arrow selection
map("i", "<S-Up>",    "<C-o>v<Up>",    "Select up")
map("i", "<S-Down>",  "<C-o>v<Down>",  "Select down")
map("i", "<S-Left>",  "<C-o>v<Left>",  "Select left")
map("i", "<S-Right>", "<C-o>v<Right>", "Select right")

-- Delete selection with backspace in visual mode
map("v", "<BS>", "d", "Delete selection")

-- Tabs
map("n", "<C-n>",       "<cmd>tabnew<CR>",          "New tab")
map("n", "<C-w>",       "<cmd>tabclose<CR>",         "Close tab")
map("n", "<S-M-Left>",  "<cmd>BufferPrevious<CR>",   "Previous buffer")
map("n", "<S-M-Right>", "<cmd>BufferNext<CR>",       "Next buffer")
map("n", "<leader>bc",  "<cmd>BufferClose<CR>",      "Close buffer")
map("n", "<leader>bp",  "<cmd>BufferPin<CR>",        "Pin buffer")

-- File trees
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle nvim-tree")
map("n", "<C-l>",     "<cmd>NvimTreeToggle<CR>", "Toggle nvim-tree")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",               "Find files")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",                "Live grep (rg)")
map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>",             "File browser")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",                 "Recent files")
map("n", "<leader>fs", "<cmd>Telescope grep_string<CR>",              "Grep word under cursor")
map("n", "<leader>fz", "<cmd>Telescope zoxide list<CR>",              "Zoxide jump")
map("n", "<leader>fc", "<cmd>Telescope commands<CR>",                 "Commands")
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>",                  "Keymaps")
map("n", "<C-f>",      "<cmd>Telescope current_buffer_fuzzy_find<CR>","Search in buffer")

-- fzf-lua (bat-previewed; <leader>F prefix)
map("n", "<leader>Ff", "<cmd>FzfLua files<CR>",     "fzf: files")
map("n", "<leader>Fg", "<cmd>FzfLua live_grep<CR>", "fzf: live grep")
map("n", "<leader>Fb", "<cmd>FzfLua buffers<CR>",   "fzf: buffers")

-- Window management
map("n", "<leader>-",  "<cmd>split<CR>",  "Split horizontal")
map("n", "<leader>|",  "<cmd>vsplit<CR>", "Split vertical")
map("n", "<leader>wh", "<C-w>h",          "Move to left window")
map("n", "<leader>wl", "<C-w>l",          "Move to right window")
map("n", "<leader>wj", "<C-w>j",          "Move to bottom window")
map("n", "<leader>wk", "<C-w>k",          "Move to top window")

-- Case-insensitive commands
for _, cmd in ipairs({ "Q", "W", "Wq", "WQ", "Qa", "QA" }) do
  local lower = cmd:lower()
  vim.api.nvim_create_user_command(cmd, lower, {})
end

-- Auto-commands

-- Auto-reload file changed outside Neovim
vim.api.nvim_create_augroup("AutoRead", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group   = "AutoRead",
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group    = "AutoRead",
  pattern  = "*",
  callback = function()
    vim.notify("File changed on disk – buffer reloaded!", vim.log.levels.WARN, { title = "nvim" })
  end,
})

-- Restore cursor shape on exit (Alacritty / Ghostty)
vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
  group   = "RestoreCursor",
  pattern = "*",
  command = "set guicursor=a:ver25-blinkwait400-blinkoff400-blinkon400",
})

-- Highlight yanked text briefly
vim.api.nvim_create_augroup("YankHL", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = "YankHL",
  pattern  = "*",
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Trim trailing whitespace on save (cursor-position safe)
vim.api.nvim_create_augroup("TrimWS", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = "TrimWS",
  pattern  = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})
