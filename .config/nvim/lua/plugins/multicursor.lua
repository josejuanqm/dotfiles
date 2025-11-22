return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	dependencies = { "folke/which-key.nvim" },
	config = function()
		local mc = require("multicursor-nvim")
		local wk = require("which-key")
		mc.setup()

		-- Register with which-key
		wk.add({
			{ "<leader>m", group = "Multicursor" },
			{
				"<leader>mn",
				function()
					mc.matchAddCursor(1)
				end,
				desc = "Add cursor on next match",
				mode = { "n", "x" },
			},
			{
				"<leader>ms",
				function()
					mc.matchSkipCursor(1)
				end,
				desc = "Skip next match",
				mode = { "n", "x" },
			},
			{
				"<leader>mN",
				function()
					mc.matchAddCursor(-1)
				end,
				desc = "Add cursor on prev match",
				mode = { "n", "x" },
			},
			{
				"<leader>mS",
				function()
					mc.matchSkipCursor(-1)
				end,
				desc = "Skip prev match",
				mode = { "n", "x" },
			},
			{
				"<leader>m<up>",
				function()
					mc.lineSkipCursor(-1)
				end,
				desc = "Skip cursor above",
				mode = { "n", "x" },
			},
			{
				"<leader>m<down>",
				function()
					mc.lineSkipCursor(1)
				end,
				desc = "Skip cursor below",
				mode = { "n", "x" },
			},
			{
				"<c-q>",
				mc.toggleCursor,
				desc = "Toggle cursor",
				mode = { "n", "x" },
			},
			-- Arrow key bindings (not shown in which-key menu to reduce clutter)
			{
				"<up>",
				function()
					mc.lineAddCursor(-1)
				end,
				mode = { "n", "x" },
			},
			{
				"<down>",
				function()
					mc.lineAddCursor(1)
				end,
				mode = { "n", "x" },
			},
		})

		-- Mouse bindings
		vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
		vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
		vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor)
			layerSet({ "n", "x" }, "<right>", mc.nextCursor)

			-- Delete the main cursor.
			layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end)
		end)

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
