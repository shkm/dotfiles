local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'
local lir = require 'lir'

lir.setup {
	show_hidden_files = true,
	devicons_enable = true,
	mappings = {
		['l']     = actions.edit,
		['<CR>']     = actions.edit,
		['<C-s>'] = actions.split,
		['<C-v>'] = actions.vsplit,
		['<C-t>'] = actions.tabedit,
		['<C-r>'] = actions.reload,

		['h']     = actions.up,
		['-']     = actions.up,
		['q']     = actions.quit,

		['K']     = actions.mkdir,
		['N']     = actions.newfile ,
		['R']     = actions.rename,
		['@']     = actions.cd,
		['Y']     = actions.yank_path,
		['.']     = actions.toggle_show_hidden,
    ['D'] = function()
      local ctx = lir.get_context()
      local name = ctx:current_value()
      local Path = require("plenary.path")

      if vim.fn.confirm("Trash?: " .. name, "&Yes\n&No", 1) ~= 1 then
        return
      end

      local path = Path:new(ctx.dir .. name):absolute()
      vim.cmd('silent !$HOME/scripts/trash "' .. path .. '"')
      vim.cmd('silent edit') -- we don't use actions.reload because it returns a message
    end,
    ['O'] = function()
      local ctx = lir.get_context()
      io.popen('$HOME/scripts/open ' .. ctx.dir)
    end,
		['J'] = function()
			mark_actions.toggle_mark()
			-- vim.cmd('normal! j')
		end,
		['C'] = clipboard_actions.copy,
		['X'] = clipboard_actions.cut,
		['P'] = clipboard_actions.paste,
	},
	float = {
		winblend = 0,
		curdir_window = {
			enable = false,
			highlight_dirname = false
		},

		-- -- You can define a function that returns a table to be passed as the third
		-- -- argument of nvim_open_win().
		-- win_opts = function()
		--   local width = math.floor(vim.o.columns * 0.8)
		--   local height = math.floor(vim.o.lines * 0.8)
		--   return {
		--     border = require("lir.float.helper").make_border_opts({
		--       "+", "─", "+", "│", "+", "─", "+", "│",
		--     }, "Normal"),
		--     width = width,
		--     height = height,
		--     row = 1,
		--     col = math.floor((vim.o.columns - width) / 2),
		--   }
		-- end,
	},
	hide_cursor = true,
}

-- use visual mode
function _G.LirSettings()
  vim.api.nvim_buf_set_keymap(0, 'x', 'J', ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>', {noremap = true, silent = true})

  -- echo cwd
  vim.api.nvim_echo({{vim.fn.expand('%:p'), 'Normal'}}, false, {})
end

vim.cmd [[augroup lir-settings]]
vim.cmd [[  autocmd!]]
vim.cmd [[  autocmd Filetype lir :lua LirSettings()]]
vim.cmd [[augroup END]]
