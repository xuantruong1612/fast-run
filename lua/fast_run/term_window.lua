local api = vim.api
local M = {}

function M.open_and_run(cmd)
	vim.cmd("vertical rightbelow vsplit")
	vim.cmd("vertical resize 50")
	vim.cmd(cmd)
	vim.cmd("startinsert")

	-- Thiết lập keymap trong terminal
	api.nvim_buf_set_keymap(0, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(0, "t", "<Up>", "<C-\\><C-n><Up>", { noremap = true, silent = true })
	api.nvim_buf_set_keymap(0, "t", "<Down>", "<C-\\><C-n><Down>", { noremap = true, silent = true })
end

return M
