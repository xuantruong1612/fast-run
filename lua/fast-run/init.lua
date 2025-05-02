local M = {}

local config = require("fast-run.config")

function M.setup(opts)
	-- Cấu hình các ngôn ngữ hỗ trợ
	config.setup(opts)
	-- Đăng ký các autocmd và ánh xạ phím
	require("fast-run.ui").register()
end

return M
