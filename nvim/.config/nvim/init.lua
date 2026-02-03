-- Simplified Neovim config based on kickstart.nvim
-- Migrated from LazyVim

vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Disable netrw (use oil instead)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

-- [[ Options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.filetype.add({
  pattern = {
    [".*%.yaml%..*"] = "yaml",
  },
})

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- [[ Neovide ]]
if vim.g.neovide then
  vim.g.neovide_padding_top = 15
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_transparency = 0.0
  vim.g.transparency = 0.98
  local alpha = function()
    return string.format("%x", math.floor(255 * vim.g.transparency or 0.95))
  end
  vim.g.neovide_background_color = "#1e1e2e" .. alpha()
  vim.g.neovide_window_blurred = true
end

-- [[ Custom Keymaps ]]
-- Swap ; and :
vim.keymap.set({ "n", "v" }, ":", ";", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true, silent = true })

-- 0 goes to first non-blank character
vim.keymap.set("n", "0", "^", { noremap = true, silent = true })

-- Alternate file
vim.keymap.set("n", "<Leader><Tab>", "<C-^>", { noremap = true, silent = true, desc = "Alternate file" })

-- Exit insert/terminal mode with jk
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window navigation (handled by smart-splits for Kitty integration)

-- Terminal escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal reflow - force resize to trigger reflow
local function terminal_reflow()
  local win = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(win)
  vim.api.nvim_win_set_height(win, height - 1)
  vim.api.nvim_win_set_height(win, height)
end
vim.keymap.set({ "n", "t" }, "<C-S-l>", terminal_reflow, { desc = "Reflow terminal" })

-- Terminal conveniences (I to enter insert at start of line)
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "I", "i<C-a>", { buffer = true, noremap = true, silent = true, desc = "Enter terminal, go to start of line" })
  end,
})


-- Diagnostic quickfix
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix" })

-- [[ Custom Commands ]]
vim.api.nvim_create_user_command("PrettyJson", "%!python -m json.tool", {})
vim.api.nvim_create_user_command("PrettyHtml", "%!tidy -q -i --show-errors 0 --raw", {})
vim.api.nvim_create_user_command("PrettyXml", "%!tidy -q -i -xml --show-errors 0 --raw", {})

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close gitsigns blame with q or <leader>gb",
  pattern = "gitsigns-blame",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
    vim.keymap.set("n", "<leader>gb", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "TermLeave", "WinLeave" }, {
  desc = "Switch to normal mode when leaving terminal",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("stopinsert")
    end
  end,
})

-- Forward bell to kitty and mark the tab containing the calling terminal
function _G.forward_bell(pid)
  io.stdout:write("\a")
  io.stdout:flush()

  -- Find which terminal buffer owns this PID by walking up the process tree
  local function get_ppid(p)
    local handle = io.popen("ps -o ppid= -p " .. p .. " 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      return tonumber(result:match("%d+"))
    end
  end

  -- Build set of ancestor PIDs
  local ancestors = {}
  local current_pid = pid
  while current_pid and current_pid > 1 do
    ancestors[current_pid] = true
    current_pid = get_ppid(current_pid)
  end

  -- Find terminal buffer whose job PID is in our ancestor chain
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
    if tabnr ~= current_tab then
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          local job_pid = vim.b[buf].terminal_job_pid
          if job_pid and ancestors[job_pid] then
            vim.t[tabnr].has_bell = true
            vim.cmd("redrawtabline")
            return
          end
        end
      end
    end
  end
  vim.cmd("redrawtabline")
end

vim.api.nvim_create_autocmd("TermRequest", {
  desc = "Forward terminal bells to kitty and mark vim tabs",
  callback = function(args)
    if args.data == "\x07" then
      local bufnr = args.buf
      local pid = vim.b[bufnr].terminal_job_pid
      _G.forward_bell(pid)
    end
  end,
})

-- Clear bell indicator when entering a tab
vim.api.nvim_create_autocmd("TabEnter", {
  desc = "Clear bell indicator on tab enter",
  callback = function()
    vim.t.has_bell = nil
  end,
})

-- Test command: run `:TestBell` in a terminal buffer to test notifications
vim.api.nvim_create_user_command("TestBell", function()
  local chan = vim.b.terminal_job_id
  if chan then
    vim.api.nvim_chan_send(chan, "printf '\\a'\n")
  else
    vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
  end
end, {})


-- [[ Install lazy.nvim ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require("lazy").setup({
  -- Claude Code - AI assistant terminal integration
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      window = {
        position = "botright",
        split_ratio = 0.75,
        enter_insert = false,
      },
      keymaps = {
        toggle = {
          normal = "<C-'>",
          terminal = "<C-'>",
          variants = {},
        },
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "Resume conversation" },
    },
  },

  -- Smart splits - seamless navigation with Kitty (not lazy-loaded for IS_NVIM var)
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    build = "./kitty/install-kittens.bash",
    opts = {
      at_edge = "stop",
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
      -- Navigation (normal mode only - use jk or Esc to exit terminal insert first)
      local function nav_with_stopinsert(direction)
        return function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("stopinsert")
          end
          require("smart-splits")["move_cursor_" .. direction]()
        end
      end
      vim.keymap.set("n", "<C-h>", nav_with_stopinsert("left"), { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", nav_with_stopinsert("down"), { desc = "Move to below split" })
      vim.keymap.set("n", "<C-k>", nav_with_stopinsert("up"), { desc = "Move to above split" })
      vim.keymap.set("n", "<C-l>", nav_with_stopinsert("right"), { desc = "Move to right split" })
      -- Resize
      vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left, { desc = "Resize left" })
      vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down, { desc = "Resize down" })
      vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up, { desc = "Resize up" })
      vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right, { desc = "Resize right" })
    end,
  },

  -- CodeDiff - VSCode-style diff view
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },

  -- Orchard - worktree manager (local dev)
  {
    dir = "~/repos/orchard.nvim",
    dependencies = { "esmuellert/codediff.nvim" },
    event = "VeryLazy",
    cmd = "Orchard",
    opts = {},
    keys = {
      { "<leader>w", nil, desc = "Worktree" },
      { "<leader>wc", "<cmd>Orchard create<cr>", desc = "Create worktree" },
      { "<leader>wf", "<cmd>Orchard pick<cr>", desc = "Find worktree" },
      { "<leader>fw", "<cmd>Orchard pick<cr>", desc = "Find worktree" },
      { "<leader>wm", "<cmd>Orchard merge<cr>", desc = "Merge to main" },
      { "<leader>wd", "<cmd>Orchard diff<cr>", desc = "Diff worktree" },
      { "<leader>wD", "<cmd>Orchard delete<cr>", desc = "Delete worktree" },
    },
  },

  -- Vimade - fade inactive windows
  {
    "tadaa/vimade",
    event = "VeryLazy",
    config = function()
      require("vimade").setup({
        recipe = { "minimalist", { animate = true } },
        fadelevel = 0.7, -- Milder dimming (0.4 is default, 1.0 is no fade)
        ncmode = "buffers", -- Use buffer focus instead of window focus
      })
      -- Force vimade refresh when entering terminal mode
      vim.api.nvim_create_autocmd("TermEnter", {
        callback = function()
          vim.schedule(function()
            pcall(vim.cmd, "VimadeRedraw")
          end)
        end,
      })
    end,
  },

  -- Snacks.nvim - QoL plugins collection
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      -- Open file in current nvim and close lazygit when editing
      lazygit = {
        config = {
          os = {
            editPreset = "",
            editInTerminal = false,
            edit = "nvim --server $NVIM --remote {{filename}}; nvim --server $NVIM --remote-send 'q'",
          },
          promptToReturnFromSubprocess = false,
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              -- Emacs keybindings in insert mode
              ["<C-a>"] = { "<Home>", mode = "i", expr = true },
              ["<C-e>"] = { "<End>", mode = "i", expr = true },
              ["<C-b>"] = { "<Left>", mode = "i", expr = true },
              ["<C-f>"] = { "<Right>", mode = "i", expr = true },
              ["<C-d>"] = { "<Del>", mode = "i", expr = true },
              ["<C-k>"] = { "<C-o>D", mode = "i", expr = true },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      words = { enabled = true },
    },
    keys = {
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Find word",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find buffers",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Find help",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Find keymaps",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Find diagnostics",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Find resume",
      },
      {
        "<leader>f.",
        function()
          Snacks.picker.recent()
        end,
        desc = "Find recent files",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Find in project",
      },
      {
        "<leader>fn",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find nvim config",
      },
      {
        "<leader>ft",
        function()
          local tabs = {}
          local current = vim.api.nvim_get_current_tabpage()
          for i, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
            local name = vim.t[tabnr].name
            if not name then
              local ok, cwd = pcall(vim.fn.getcwd, -1, tabnr)
              name = ok and vim.fn.fnamemodify(cwd, ":t") or tostring(i)
            end
            local prefix = tabnr == current and "* " or "  "
            table.insert(tabs, { display = prefix .. name, tabnr = tabnr })
          end
          vim.ui.select(tabs, {
            prompt = "Tabs:",
            format_item = function(item)
              return item.display
            end,
          }, function(item)
            if item then
              vim.api.nvim_set_current_tabpage(item.tabnr)
            end
          end)
        end,
        desc = "Find tabs",
      },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev reference",
        mode = { "n", "t" },
      },
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff" },
    },
  },

  -- Emacs-style editing in insert/command mode
  "tpope/vim-rsi",

  -- Move function arguments left/right with H/L
  {
    "AndrewRadev/sideways.vim",
    cmd = { "SidewaysLeft", "SidewaysRight" },
    keys = {
      { "H", ":SidewaysLeft<CR>", desc = "Move argument left" },
      { "L", ":SidewaysRight<CR>", desc = "Move argument right" },
    },
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function toggle_blame()
          -- Find and close any existing gitsigns-blame window
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "gitsigns-blame" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          gs.blame()
        end

        vim.keymap.set("n", "<leader>gb", toggle_blame, { buffer = bufnr, desc = "Git blame" })
        vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Previous hunk" })
      end,
    },
  },

  -- Which-key for keybind hints
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { "<leader>a", group = "AI/Claude" },
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Toggle" },
        { "<leader>w", group = "Worktree" },
      },
    },
  },

  -- LSP
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("grr", function()
            Snacks.picker.lsp_references()
          end, "References")
          map("gri", function()
            Snacks.picker.lsp_implementations()
          end, "Implementation")
          map("grd", function()
            Snacks.picker.lsp_definitions()
          end, "Definition")
          map("grD", vim.lsp.buf.declaration, "Declaration")
          map("grt", function()
            Snacks.picker.lsp_type_definitions()
          end, "Type definition")
          map("gO", function()
            Snacks.picker.lsp_symbols()
          end, "Document symbols")
          map("gW", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "Workspace symbols")

          -- Keep traditional Ctrl-] for definition
          map("<C-]>", vim.lsp.buf.definition, "Definition")

          -- Toggle inlay hints
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle inlay hints")
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = { source = "if_many", spacing = 2 },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Add language servers here as needed
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            -- Only set up servers we explicitly configure
            if not servers[server_name] then
              return
            end
            local server = servers[server_name]
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>bf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true, yaml = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  -- Completion with blink.cmp (Tab to confirm, no Enter)
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "2.*", build = "make install_jsregexp", opts = {} },
      "folke/lazydev.nvim",
    },
    opts = {
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            local copilot = require("copilot.suggestion")
            if copilot.is_visible() then
              copilot.accept()
              return true
            end
            return cmp.accept() or cmp.snippet_forward()
          end,
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        -- No Enter to confirm
      },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
      snippets = { preset = "luasnip" },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-k>",
          accept_line = "<M-j>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    },
  },

  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        no_italic = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  -- File explorer (edit directories as buffers)
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      win_options = {
        winbar = "%!v:lua.require('oil').get_current_dir()",
      },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-h>"] = false, -- Use global smart-splits mapping instead of toggle hidden
        ["<C-l>"] = false, -- Use global smart-splits mapping instead of refresh
      },
    },
  },

  -- Lualine - statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = vim.g.have_nerd_font,
        theme = "catppuccin",
      },
      sections = {
        lualine_x = { "overseer" },
      },
    },
  },

  -- Overseer - task runner
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerOpen", "OverseerClose", "OverseerToggle", "OverseerRun" },
    keys = {
      { "<leader>e", nil, desc = "Execute" },
      { "<leader>er", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>eo", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    },
    opts = {},
  },

  -- Mini.nvim modules
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      require("mini.splitjoin").setup() -- gS to toggle
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
