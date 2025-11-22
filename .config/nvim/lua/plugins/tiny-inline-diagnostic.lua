return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "modern", -- Can be: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
			options = {
				show_source = true,
				multilines = true,
				overflow = {
					mode = "wrap",
				},
			},
		})

		-- Disable default virtual text diagnostics since we're using tiny-inline-diagnostic
		vim.diagnostic.config({
			virtual_text = false,
		})
	end,
}
