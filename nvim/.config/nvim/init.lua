-- Bootstrap lazy
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
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	"tpope/vim-surround",
	"tpope/vim-commentary",
	"tpope/vim-unimpaired",
	"tpope/vim-rsi",
	"tpope/vim-fugitive",
	"adelarsq/vim-matchit",
	"AndrewRadev/splitjoin.vim",
	-- {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
	{ "sheerun/vim-polyglot", init = function()
		vim.api.nvim_create_autocmd({'FileType'}, {
			pattern = { 'json5' },
			command = 'setlocal commentstring=// %s'
		})
		vim.g.vim_markdown_folding_disable = 1
	end
},
{ "dracula/vim", config = function()
	vim.cmd.colorscheme("dracula")
end },
{ "nvim-lualine/lualine.nvim", config = function()
	require('lualine').setup {
		options = {
			theme = 'dracula'
		}
	}
end },
"nvim-tree/nvim-web-devicons",
{"tamago324/lir.nvim", dependencies = { 'nvim-lua/plenary.nvim' }, init = function()
	local actions = require'lir.actions'
	local mark_actions = require 'lir.mark.actions'
	local clipboard_actions = require'lir.clipboard.actions'
	local lir = require 'lir'

	lir.setup {
		show_hidden_files = true,
		devicons = { enable = true },
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
end },
{"neovim/nvim-lspconfig", config = function()
	-- Mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	local opts = { noremap=true, silent=true }
	-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap=true, silent=true, buffer=bufnr }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
		-- vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
		-- vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
		-- vim.keymap.set('n', '<Leader>wl', function()
		--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end, bufopts)
		vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, bufopts)
		vim.keymap.set('n', '<Leader>lc', vim.lsp.buf.code_action, bufopts)
		vim.keymap.set('n', '<Leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	end

	local lsp_flags = {
		-- This is the default in Nvim 0.7+
		debounce_text_changes = 150,
	}
	require('lspconfig')['gopls'].setup{
		on_attach = on_attach,
		flags = lsp_flags,
	}
end
},
{
	"folke/trouble.nvim", config = function()
		require("trouble").setup {}
	end
},
{
	"nvim-telescope/telescope.nvim", dependencies = { 'nvim-lua/plenary.nvim' }, config = function()
		local trouble = require("trouble.providers.telescope")
		require("telescope").setup {
			defaults = {
				mappings = {
					i = { ["<c-t>"] = trouble.open_with_trouble },
					n = { ["<c-t>"] = trouble.open_with_trouble },
				}
			}
		}
	end
},
{ "folke/which-key.nvim", config = function()
	require("which-key").setup {
		plugins = {
			spelling = {
				enabled = true
			}
		}
	}
end },
{ "mhartington/formatter.nvim", config = function()
	local util = require "formatter.util"

	require("formatter").setup {
		logging = true;
		filetype = {
			ruby = {
				function()
					return {
						exec = "rubyfmt",
						args = {
							"--",
							util.escape_path(util.get_current_buffer_file_path())
						}
					}
				end
			},
			go = {
				require("formatter.filetypes.go").gofmt
			}
		}
	}
end
},

}, opts)

vim.cmd.source "$HOME/.config/nvim/basics.vim"


