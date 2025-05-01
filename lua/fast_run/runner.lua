local M = {}

function M.get_run_command()
	local filetype = vim.bo.filetype
	local fullpath = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local filename_noext = vim.fn.expand("%:t:r")
	local output_path = string.format("%s/%s", dir, filename_noext)

	if filetype == "c" then
		return string.format(
			'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
			output_path,
			fullpath,
			output_path
		)
	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)
	elseif filetype == "python" then
		return string.format('term python3 "%s"', fullpath)
	elseif filetype == "java" then
		return string.format('term javac "%s" && cd "%s" && java "%s"', fullpath, dir, filename_noext)
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', fullpath)
	else
		return nil
	end
end

return M
