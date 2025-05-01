local runner = require("fast_run.runner")
local term = require("fast_run.term_window")

local M = {}

function M.setup(opts)
	opts = opts or {}
	runner.set_custom_commands(opts.custom_commands or {})

	vim.keymap.set("n", "<leader>t", function()
		if vim.fn.expand("%") == "" then
			print("Buffer chưa được lưu vào file")
			return
		end
		vim.cmd("w")
		local cmd = runner.get_run_command()

		if not cmd then
			print("No support file =))")
			return
		end

		term.open_and_run(cmd)
	end, { noremap = true, silent = true })
end

return M
