local runner = require("fast_run.runner")
local term = require("fast_run.term_window")

local M = {}

function M.setup(opts)
	opts = opts or {}
	runner.set_custom_commands(opts.custom_commands or {})

	vim.keymap.set("n", "<leader>t", function()
		-- Bước 1: kiểm tra có hỗ trợ filetype không
		local cmd = runner.get_run_command()
		if not cmd then
			vim.notify("⚠️ Filetype này chưa được hỗ trợ để chạy.", vim.log.levels.WARN)
			return
		end

		-- Bước 2: kiểm tra buffer có được lưu tên chưa
		local filename = vim.api.nvim_buf_get_name(0)
		if filename == "" then
			vim.notify("❌ Buffer chưa được lưu thành file!", vim.log.levels.WARN)
			return
		end

		-- Bước 3: lưu nếu có sửa đổi
		if vim.bo.modified then
			vim.cmd("write")
		end

		-- Bước 4: chạy
		term.open_and_run(cmd)
	end, { noremap = true, silent = true })
end

return M
