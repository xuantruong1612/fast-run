local api = vim.api

local M = {}

function M.open_and_run(cmd)
	vim.cmd("vsplit")
	vim.cmd("vertical resize 50")
	vim.cmd(cmd)
	vim.cmd("startinsert")

	local buf = api.nvim_get_current_buf()
	api.nvim_buf_set_keymap(buf, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(buf, "t", "<Up>", "<C-\\><C-n><Up>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(buf, "t", "<Down>", "<C-\\><C-n><Down>", { noremap = true, silent = true })
end

return M
