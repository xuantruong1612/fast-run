local runner = require("fast_run.runner")
local term = require("fast_run.term_window")

local M = {}

function M.setup(opts)
	opts = opts or {}
	runner.set_custom_commands(opts.custom_commands or {})

	vim.keymap.set("n", "<leader>t", function()
		-- Lấy đường dẫn file hiện tại
		local filename = vim.api.nvim_buf_get_name(0)

		-- Nếu buffer chưa được lưu
		if filename == "" then
			vim.notify("❌ Buffer chưa được lưu thành file!", vim.log.levels.WARN)
			return
		end

		-- Lưu nếu có thay đổi
		if vim.bo.modified then
			vim.cmd("write")
		end

		-- Lấy lệnh chạy tương ứng
		local cmd = runner.get_run_command()
		if not cmd then
			vim.notify("⚠️ Không hỗ trợ filetype này.", vim.log.levels.WARN)
			return
		end

		-- Mở terminal và chạy lệnh
		term.open_and_run(cmd)
	end, { noremap = true, silent = true })
end

return M
