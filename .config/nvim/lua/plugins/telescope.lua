local builtin = require("telescope.builtin")

local lgrep = function()
	local opts = {
		find_command = function()
			return {
				"rg",
				"--files",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--no-ignore-vcs",
			}
		end,
		hidden = true,
	}
	builtin.live_grep(opts)
end

local ff = function()
	local opts = {
		find_command = function()
			return {
				"rg",
				"--files",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--no-ignore-vcs",
			}
		end,
		hidden = true,
	}
	builtin.find_files(opts)
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.1.9",
	dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		local wk = require("which-key")

		-- Register telescope keymaps with which-key
		wk.add({
			{ "<leader>f", group = "Find" },
			{ "<leader>ff", ff, desc = "Find files" },
			{ "<leader>fb", builtin.buffers, desc = "Buffers" },
			{ "<leader>fh", builtin.help_tags, desc = "Help tags" },
			{ "<leader>fc", builtin.commands, desc = "Commands" },
			{ "<leader>fs", builtin.treesitter, desc = "Treesitter symbols" },
			{ "<leader>/", lgrep, desc = "Live grep" },
			{ "<leader>fg", group = "Git" },
			{ "<leader>fgb", builtin.git_branches, desc = "Branches" },
		})

		require("telescope").setup({
			defaults = {
				layout_config = {
					vertical = { width = 0.5 },
				},
			},
			pickers = {
				find_files = {
					theme = "dropdown",
				},
				live_grep = {
					theme = "dropdown",
				},
				buffers = {
					theme = "dropdown",
				},
				help_tags = {
					theme = "dropdown",
				},
				commands = {
					theme = "dropdown",
				},
				git_branches = {
					theme = "dropdown",
				},
				treesitter = {
					theme = "dropdown",
				},
			},
		})
	end,
}
