local runner = require("fast_run.runner")
local term = require("fast_run.term_window")

local M = {}

function M.setup(opts)
	opts = opts or {}
	runner.set_custom_commands(opts.custom_commands or {})

	vim.keymap.set("n", "<leader>t", function()
		local filename = vim.fn.expand("%:p")
		if filename == "" then
			print("❌ Buffer chưa được lưu thành file!")
			return
		end

		vim.cmd("write")

		local cmd = runner.get_run_command()
		if not cmd then
			print("⚠️ Không hỗ trợ filetype này.")
			return
		end

		term.open_and_run(cmd)
	end, { noremap = true, silent = true })
end

return M
