return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Enable LSP capabilities for autocomplete
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure servers using vim.lsp.config
		vim.lsp.config["*"] = {
			capabilities = capabilities,
		}

		-- Swift (iOS)
		vim.lsp.config.sourcekit = {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift" },
			root_markers = {
				"compile_commands.json",
				".xcworkspace",
				".xcodeproj",
				"Podfile",
				"Package.swift",
				".git",
			},
		}

		-- TypeScript/JavaScript
		vim.lsp.config.ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
		}

		-- Svelte
		vim.lsp.config.svelte = {
			cmd = { "svelteserver", "--stdio" },
			filetypes = { "svelte" },
			root_markers = { "package.json", "svelte.config.js" },
			on_attach = function(client)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		}

		-- Tailwind CSS
		vim.lsp.config.tailwindcss = {
			cmd = { "tailwindcss-language-server", "--stdio" },
			filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
			root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.cjs" },
		}

		-- HTML
		vim.lsp.config.html = {
			cmd = { "vscode-html-language-server", "--stdio" },
			filetypes = { "html" },
			root_markers = { "package.json" },
		}

		-- CSS
		vim.lsp.config.cssls = {
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = { "css", "scss", "less" },
			root_markers = { "package.json" },
		}

		-- Lua (Neovim config)
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}

		-- Enable all configured servers
		local servers = { "sourcekit", "ts_ls", "svelte", "tailwindcss", "html", "cssls", "lua_ls" }
		for _, server in ipairs(servers) do
			vim.lsp.enable(server)
		end

		-- LSP keymaps with which-key integration
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local wk = require("which-key")

				-- Register LSP keymaps with descriptions
				wk.add({
					{ "gd", vim.lsp.buf.definition, buffer = ev.buf, desc = "Go to definition" },
					{ "gD", vim.lsp.buf.declaration, buffer = ev.buf, desc = "Go to declaration" },
					{ "K", vim.lsp.buf.hover, buffer = ev.buf, desc = "Hover documentation" },
					{ "gi", vim.lsp.buf.implementation, buffer = ev.buf, desc = "Go to implementation" },
					{ "gr", vim.lsp.buf.references, buffer = ev.buf, desc = "Find references" },
					{ "gs", vim.lsp.buf.signature_help, buffer = ev.buf, desc = "Signature help" },
					{ "gl", vim.diagnostic.open_float, buffer = ev.buf, desc = "Show diagnostics" },
					{ "[d", vim.diagnostic.goto_prev, buffer = ev.buf, desc = "Previous diagnostic" },
					{ "]d", vim.diagnostic.goto_next, buffer = ev.buf, desc = "Next diagnostic" },
					{
						"<leader>l",
						group = "LSP",
						buffer = ev.buf,
						{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename symbol" },
						{ "<leader>la", vim.lsp.buf.code_action, desc = "Code action" },
						{ "<leader>lf", vim.lsp.buf.format, desc = "Format buffer" },
						{ "<leader>ld", vim.diagnostic.open_float, desc = "Show diagnostics" },
						{ "<leader>lq", vim.diagnostic.setloclist, desc = "Diagnostics to loclist" },
					},
				})
			end,
		})
	end,
}
