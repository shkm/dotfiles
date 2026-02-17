return {
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

  -- Lualine - statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local catppuccin = require("catppuccin.palettes").get_palette("mocha")
      local bg = catppuccin.mantle
      local flat = { bg = bg }
      local theme = require("lualine.themes.catppuccin")
      for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }) do
        if theme[mode] then
          theme[mode].b = flat
          theme[mode].c = flat
          if theme[mode].x then theme[mode].x = flat end
          theme[mode].y = flat
          theme[mode].z = flat
        end
      end
      return {
        options = {
          icons_enabled = false,
          theme = theme,
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = {
            { "mode", fmt = function(s) return s:sub(1, 1) end },
          },
          lualine_b = { { "branch", color = { fg = catppuccin.subtext0 } } },
          lualine_c = { "filename" },
          lualine_x = {
            {
              function() return "AGENT" end,
              cond = function() return vim.g.claude_awaiting_input end,
              color = "DiagnosticWarn",
            },
            { "filetype", color = { fg = catppuccin.overlay0 } },
          },
          lualine_y = { { function() return "%l" end, color = { fg = catppuccin.subtext0 } } },
          lualine_z = { { function() return "%p%%" end, color = { fg = catppuccin.overlay0 } } },
        },
        inactive_sections = {
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },

  -- Vimade - fade inactive windows
  {
    "tadaa/vimade",
    event = "VeryLazy",
    config = function()
      require("vimade").setup({
        recipe = { "minimalist", { animate = true } },
        fadelevel = 0.7,
        ncmode = "buffers",
        blocklist = {
          default = {
            buf_name = { "codediff" },
          },
        },
      })
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
    init = function()
      _G.picker_opts = function()
        if vim.fn.getcwd():match("/dotfiles$") then
          return { hidden = true }
        end
        return {}
      end
    end,
    opts = {
      bigfile = { enabled = true },
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
      { "<leader>ff", function() Snacks.picker.files(picker_opts()) end, desc = "Find files" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Find word" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Find help" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Find diagnostics" },
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Find resume" },
      { "<leader>f.", function() Snacks.picker.recent() end, desc = "Find recent files" },
      { "<leader>/", function() Snacks.picker.grep(picker_opts()) end, desc = "Find in project" },
      { "<leader>on", function() Snacks.notifier.show_history() end, desc = "Open notifications" },
      { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find nvim config" },
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
            format_item = function(item) return item.display end,
          }, function(item)
            if item then vim.api.nvim_set_current_tabpage(item.tabnr) end
          end)
        end,
        desc = "Find tabs",
      },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff" },
    },
  },
}
