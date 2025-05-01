local M = {}

function M.set_terminal_keymaps()
	-- Normal mode: <CR> để quit cửa sổ terminal
	vim.api.nvim_buf_set_keymap(0, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })

	-- Terminal mode: điều hướng bằng phím mũi tên
	vim.api.nvim_buf_set_keymap(0, "t", "<Up>", "<C-\\><C-n><Up>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "t", "<Down>", "<C-\\><C-n><Down>", { noremap = true, silent = true })
end

return M
