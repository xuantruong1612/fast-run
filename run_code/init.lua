local M = {}

function M.enable()
	-- Đặt keymap hoặc cấu hình plugin ở đây
	vim.keymap.set("n", "<leader>t", function()
		-- logic chạy file
	end, { noremap = true, silent = true })
end

return M
