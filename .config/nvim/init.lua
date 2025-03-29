-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
	  { "nvim-treesitter/nvim-treesitter" },
	  {
		  "neovim/nvim-lspconfig",
		  depencendies = {
			  { "antosha417/nvim-lsp-file-operations", config = true },
		  },
		  event = { "BufReadPre", "BufNewFile" },
		  config = function()
			 local map = vim.api.nvim_set_keymap
			 map("n", "X", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
		  end
	  },
	  {
		  "luckasRanarison/tailwind-tools.nvim",
		  name = "tailwind-tools",
		  build = ":UpdateRemotePlugins",
		  dependencies = {
		    "nvim-treesitter/nvim-treesitter",
		    "neovim/nvim-lspconfig",
		  },
		  opts = {}
	  },
	  {
		  "hrsh7th/nvim-cmp",
		  dependencies = {
			  "hrsh7th/cmp-nvim-lsp",
			  "hrsh7th/cmp-buffer",
			  "hrsh7th/cmp-path",
			  "hrsh7th/cmp-cmdline"
		  },
		  config = function()
			  -- Set up nvim-cmp.
			  local cmp = require"cmp"
			  local keymap = vim.keymap -- for conciseness
			  local opts = { noremap = true, silent = true }

			  cmp.setup({
			    snippet = {
			      expand = function(args)
				vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
			      end,
			    },
			    window = {
			      -- completion = cmp.config.window.bordered(),
			      -- documentation = cmp.config.window.bordered(),
			    },
			    mapping = cmp.mapping.preset.insert({
			      ["<C-p>"] = cmp.mapping.scroll_docs(-4),
			      ["<C-n>"] = cmp.mapping.scroll_docs(4),
			      ["<C-k>"] = cmp.mapping.select_prev_item(),
			      ["<C-j>"] = cmp.mapping.select_next_item(),
			      ["<C-Space>"] = cmp.mapping.complete(),
			      ["<C-e>"] = cmp.mapping.abort(),
			      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			    }),
			    sources = cmp.config.sources({
			      { name = "nvim_lsp" },
			    }, {
			      { name = "buffer" },
			    })
			  })
			  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
			  cmp.setup.cmdline({ "/", "?" }, {
			    mapping = cmp.mapping.preset.cmdline(),
			    sources = {
			      { name = "buffer" }
			    }
			  })
			  -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
			  cmp.setup.cmdline(":", {
			    mapping = cmp.mapping.preset.cmdline(),
			    sources = cmp.config.sources({
			      { name = "path" }
			    }, {
			      { name = "cmdline" }
			    }),
			    matching = { disallow_symbol_nonprefix_matching = false }
			  })

			  -- Set up lspconfig.
			  local capabilities = vim.lsp.protocol.make_client_capabilities()
			  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			  -- This function gets run when an LSP connects to a particular buffer.
			  local on_attach = function(_, bufnr)
				opts.buffer = bufnr

				-- set keybindings
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions trim_text=true<cr>", opts)

				opts.desc = "Show LSP definitions in split"
				keymap.set("n", "gD", "<cmd>vsplit | Telescope lsp_definitions trim_text=true<cr>", opts)

				opts.desc = "Show LSP references"
				vim.keymap.set(
				"n",
				"gr",
				"<cmd>Telescope lsp_references trim_text=true include_declaration=false<cr>",
				opts
				)

				opts.desc = "Show LSP implementation"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

				opts.desc = "Show LSP code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader><leader>d", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1 })
				vim.cmd("normal! zz")
				end, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1 })
				vim.cmd("normal! zz")
				end, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rl", ":LspRestart | LspStart<CR>", opts)
			  end

			    opts.desc = "Show line diagnostics"
			    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

			  local servers = {
				  eslint = {
					  settings = {
						  workingDirectories = { mode = "auto" },
						  format = true,
					  },
					  on_attach = function(client, bufnr)
						  vim.api.nvim_create_autocmd("BufWritePre", {
							  buffer = bufnr,
							  command = "EslintFixAll",
						  })
					  end,
				  },
				  lua_ls = {
					  settings = {
						  Lua = {
							  workspace = { checkThirdParty = false },
							  telemetry = { enable = false },
							  diagnostics = {
								  globals = { "vim" },
							  },
						  },
					  }
				  },
				  ts_ls = {},
				  svelte = {},
				  sourcekit = {
					  cmd = {
						  vim.trim(vim.fn.system("xcrun -f sourcekit-lsp"))
					  }
				  }
			  }

			  for server, opt in pairs(servers) do
				  require("lspconfig")[server].setup {
					  on_attach = opt.on_attach or on_attach,
					  capabilities = capabilities,
					  cmd = opt.cmd,
					  settings = opt.settings,
					  -- Lua only
					  Lua = opt.lua,
				  }
			  end
		  end
	  },
	  {
		  "wojciech-kulik/xcodebuild.nvim",
		  dependencies = {
			  "nvim-telescope/telescope.nvim",
			  "MunifTanjim/nui.nvim",
			  "folke/snacks.nvim",
			  "nvim-tree/nvim-tree.lua",
			  "stevearc/oil.nvim",
			  "nvim-treesitter/nvim-treesitter"
		  },
		  config = function()
			  require("xcodebuild").setup{}
		  end,
	},
	{
		"ficcdaf/ashen.nvim",
		tag = "v0.11.0",
		lazy = false,
		priority = 1000,
		config = function()
			require'ashen'.load()
		end
	}
  },
  install = {  },
  checker = { enabled = true },
})
