return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/which-key.nvim",
	},
	keys = {
		{ "<leader>g", group = "Git" },
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
	},
}
