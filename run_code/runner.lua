local M = {}

function M.setup()
	vim.keymap.set("n", "<leader>t", M.run_file, { noremap = true, silent = true })
end

function M.run_file()
	vim.cmd("w") -- Save file

	local filetype = vim.bo.filetype
	local fullpath = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local filename_noext = vim.fn.expand("%:t:r")

	local output_path = string.format("%s/%s", dir, filename_noext)
	local cmd

	if filetype == "c" then
		cmd = string.format('gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"', output_path, fullpath, output_path)
	elseif filetype == "cpp" then
		cmd = string.format('g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)
	elseif filetype == "python" then
		cmd = string.format('python3 "%s"', fullpath)
	elseif filetype == "java" then
		cmd = string.format('javac "%s" && cd "%s" && java "%s"', fullpath, dir, filename_noext)
	elseif filetype == "javascript" or filetype == "js" then
		cmd = string.format('node "%s"', fullpath)
	else
		print("No support file =))")
		return
	end

	require("plugins.run_code.terminal").open_terminal(cmd)
end

return M
