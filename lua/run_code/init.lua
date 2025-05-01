local runner = require("fast_run.runner")
local term = require("fast_run.term_window")

local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("w") -- lưu file
		local cmd = runner.get_run_command()

		if not cmd then
			print("No support file =))")
			return
		end

		term.open_and_run(cmd)
	end, { noremap = true, silent = true })
end

return M
